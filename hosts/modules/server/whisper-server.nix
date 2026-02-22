{
  config,
  pkgs,
  lib,
  ...
}: let
  whisperServerScript = pkgs.writeScriptBin "whisper-server" ''
#!${pkgs.python312}/bin/python3
from faster_whisper import WhisperModel
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import tempfile
import os

# Load model once at startup (base model is good balance of speed/accuracy)
print("Loading Whisper model...")
model = WhisperModel("base", device="cpu", compute_type="int8")
print("Whisper model loaded!")

class WhisperHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/transcribe':
            content_length = int(self.headers['Content-Length'])
            audio_data = self.rfile.read(content_length)
            
            # Save to temp file
            with tempfile.NamedTemporaryFile(delete=False, suffix='.ogg') as f:
                f.write(audio_data)
                temp_path = f.name
            
            try:
                # Transcribe
                segments, info = model.transcribe(temp_path, beam_size=5)
                text = " ".join([segment.text for segment in segments])
                
                # Return JSON response
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                response = json.dumps({"text": text.strip()})
                self.wfile.write(response.encode())
            finally:
                os.unlink(temp_path)
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        # Suppress request logs
        pass

# Start server
server = HTTPServer(('127.0.0.1', 9000), WhisperHandler)
print("Whisper server listening on http://127.0.0.1:9000")
server.serve_forever()
'';
  
  pythonEnv = pkgs.python312.withPackages (ps: with ps; [
    faster-whisper
  ]);
in {
  # Create the systemd service
  systemd.services.whisper-server = {
    description = "Whisper STT Server";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "simple";
      User = "simon";
      ExecStart = "${pythonEnv}/bin/python ${whisperServerScript}/bin/whisper-server";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
  
  # Open firewall for localhost only
  networking.firewall.allowedTCPPorts = [];
}
