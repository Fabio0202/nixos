{ pkgs, ... }:
let
  dictationWorker = pkgs.writeShellApplication {
    name = "dictation-worker";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gnused
      jq
      libnotify
      pipewire
      wtype
    ];
    text = ''
      set -euo pipefail

      audio_file="$(mktemp --suffix=.wav)"
      transcript_file="$(mktemp)"

      cleanup() {
        rm -f "$audio_file" "$transcript_file" "${transcript_file}.txt"
      }
      trap cleanup EXIT

      notify-send "Dictation" "Listening… Press the toggle again to finish."

      pw-record --channels "${DICTATION_CHANNELS:-1}" --rate "${DICTATION_SAMPLE_RATE:-16000}" "$audio_file" &
      recorder_pid=$!

      stop_recording() {
        if kill -0 "$recorder_pid" 2>/dev/null; then
          kill -INT "$recorder_pid" 2>/dev/null || true
        fi
        wait "$recorder_pid" 2>/dev/null || true
      }

      trap 'stop_recording' TERM INT

      wait "$recorder_pid"

      if [ ! -s "$audio_file" ]; then
        notify-send "Dictation" "No audio captured."
        exit 0
      fi

      notify-send "Dictation" "Transcribing…"

      if [ -n "${DICTATION_WHISPER_BIN:-}" ] && [ -x "${DICTATION_WHISPER_BIN:-}" ] && [ -n "${DICTATION_WHISPER_MODEL:-}" ] && [ -f "${DICTATION_WHISPER_MODEL:-}" ]; then
        "${DICTATION_WHISPER_BIN}" \
          -m "${DICTATION_WHISPER_MODEL}" \
          -f "$audio_file" \
          -otxt \
          -of "$transcript_file" \
          >/dev/null
        raw_text="$(cat "${transcript_file}.txt")"
      elif [ -n "${OPENAI_API_KEY:-}" ]; then
        endpoint="${DICTATION_OPENAI_ENDPOINT:-https://api.openai.com/v1/audio/transcriptions}"
        model="${DICTATION_OPENAI_MODEL:-whisper-1}"
        curl_args=(
          -sS
          -X
          POST
          "$endpoint"
          -H
          "Authorization: Bearer ${OPENAI_API_KEY}"
          -F
          "model=${model}"
          -F
          "response_format=json"
          -F
          "temperature=0"
          -F
          "file=@${audio_file}"
        )
        if [ -n "${DICTATION_LANGUAGE:-}" ]; then
          curl_args+=(-F "language=${DICTATION_LANGUAGE}")
        fi
        response="$(curl "''${curl_args[@]}")"
        raw_text="$(printf '%s' "$response" | jq -r '.text // empty')"
        if [ -z "$raw_text" ]; then
          notify-send "Dictation" "Transcription failed" "$(printf '%.120s' "$response")"
          exit 1
        fi
      else
        notify-send "Dictation" "Set OPENAI_API_KEY or DICTATION_WHISPER_* for transcription."
        exit 1
      fi

      cleaned_text="$(printf '%s' "$raw_text" | tr '\r\n' ' ' | sed -e 's/[[:space:]]\+/ /g' -e 's/^[[:space:]]\+//' -e 's/[[:space:]]\+$//')"

      if [ -z "$cleaned_text" ]; then
        notify-send "Dictation" "Nothing to insert."
        exit 0
      fi

      wtype "$cleaned_text"

      notify-send "Dictation" "Inserted dictation."
    '';
  };

  dictationToggle = pkgs.writeShellApplication {
    name = "dictation-toggle";
    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      systemd
    ];
    text = ''
      set -euo pipefail

      service="dictation-listen.service"

      if systemctl --user is-active --quiet "$service"; then
        notify-send "Dictation" "Stopping…"
        systemctl --user stop "$service"
      else
        notify-send "Dictation" "Starting…"
        systemctl --user start "$service"
      fi
    '';
  };
in {
  home.packages = [
    dictationToggle
  ];

  systemd.user.services."dictation-listen" = {
    Unit = {
      Description = "Toggleable speech-to-text transcription for Hyprland";
      After = ["pipewire.service"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${dictationWorker}/bin/dictation-worker";
      EnvironmentFile = "-%h/.config/openai/api_key.env";
      PassEnvironment = [
        "OPENAI_API_KEY"
        "DICTATION_LANGUAGE"
        "DICTATION_OPENAI_ENDPOINT"
        "DICTATION_OPENAI_MODEL"
        "DICTATION_SAMPLE_RATE"
        "DICTATION_CHANNELS"
        "DICTATION_WHISPER_BIN"
        "DICTATION_WHISPER_MODEL"
      ];
    };
  };
}
