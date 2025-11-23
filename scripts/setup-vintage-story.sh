#!/usr/bin/env bash

# Vintage Story Server Setup Script
# This script helps with initial server setup after NixOS configuration

set -e

VS_DIR="/mnt/drive/vintage-story"
CONFIG_FILE="$VS_DIR/data/serverconfig.json"

echo "=== Vintage Story Server Setup ==="

# Check if server is installed
if [ ! -f "$VS_DIR/VintagestoryServer.exe" ]; then
    echo "❌ Server not found. Please run 'sudo systemctl start vintage-story-setup' first."
    exit 1
fi

echo "✅ Server files found"

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Configuration not found. Please run 'sudo systemctl start vintage-story-setup' first."
    exit 1
fi

echo "✅ Configuration found"

# Show current configuration
echo ""
echo "=== Current Server Configuration ==="
cat "$CONFIG_FILE" | jq '.'

echo ""
echo "=== Server Management Commands ==="
echo "Start server:     sudo systemctl start vintage-story"
echo "Stop server:      sudo systemctl stop vintage-story"
echo "Restart server:    sudo systemctl restart vintage-story"
echo "Check status:      sudo systemctl status vintage-story"
echo "View logs:        sudo journalctl -u vintage-story -f"
echo ""

echo "=== Server Admin Commands (run in game or console) ==="
echo "Whitelist player: /whitelist add <username>"
echo "Make admin:       /op <username>"
echo "Set password:      /serverconfig password <password>"
echo "Save world:       /autosavenow"
echo "Stop server:      /stop"
echo ""

echo "=== Port Information ==="
echo "Server port: 42420 (TCP/UDP)"
echo "Make sure to forward this port on your router if players outside your network need to connect."
echo ""

echo "=== Next Steps ==="
echo "1. Start the server: sudo systemctl start vintage-story"
echo "2. Add your username to whitelist: sudo -u simon bash -c 'cd /mnt/drive/vintage-story && dotnet VintagestoryServer.exe --dataPath ./data --command \"/whitelist add YOUR_USERNAME\"'"
echo "3. Make yourself admin: sudo -u simon bash -c 'cd /mnt/drive/vintage-story && dotnet VintagestoryServer.exe --dataPath ./data --command \"/op YOUR_USERNAME\"'"
echo "4. Connect to your server using your public IP address"
echo ""

echo "Setup complete! 🎮"