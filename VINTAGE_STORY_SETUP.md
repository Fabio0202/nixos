# Vintage Story Server Setup Guide

## 🎮 Quick Setup

### 1. Apply Configuration
```bash
sudo nixos-rebuild switch
```

### 2. Download Server Files
```bash
# Create server directory
sudo mkdir -p /mnt/drive/vintage-story/data

# Download Vintage Story Server 1.21.5
cd /tmp
curl -L "https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_1.21.5.tar.gz" -o vs_server.tar.gz

# Extract to server directory
sudo tar -xzf vs_server.tar.gz -C /mnt/drive/vintage-story/
sudo rm vs_server.tar.gz

# Set permissions
sudo chown -R simon:users /mnt/drive/vintage-story/
sudo chmod +x /mnt/drive/vintage-story/VintagestoryServer.exe
```

### 3. Create Server Configuration
```bash
# Create config file
sudo mkdir -p /mnt/drive/vintage-story/data
cat > /tmp/serverconfig.json << 'EOF'
{
  "ServerName": "Simon's Vintage Story Server",
  "ServerPort": 42420,
  "MaxClients": 10,
  "Password": null,
  "AdvertiseServer": false,
  "WhitelistMode": "default",
  "DefaultRoleCode": "suplayer",
  "SaveFileLocation": "./data/Saves/default.vcdbs",
  "ModPaths": ["Mods", "./data/Mods"]
}
EOF

# Copy config to server directory
sudo cp /tmp/serverconfig.json /mnt/drive/vintage-story/data/
sudo chown simon:users /mnt/drive/vintage-story/data/serverconfig.json
```

### 4. Start Server
```bash
sudo systemctl start vintage-story
```

### 5. Add Yourself to Whitelist
```bash
# Replace YOUR_USERNAME with your Vintage Story username
sudo -u simon bash -c 'cd /mnt/drive/vintage-story && dotnet VintagestoryServer.exe --dataPath ./data --command "/whitelist add YOUR_USERNAME"'
```

### 6. Make Yourself Admin
```bash
# Replace YOUR_USERNAME with your Vintage Story username
sudo -u simon bash -c 'cd /mnt/drive/vintage-story && dotnet VintagestoryServer.exe --dataPath ./data --command "/op YOUR_USERNAME"'
```

## 🔧 Server Management

### Start/Stop/Restart
```bash
sudo systemctl start vintage-story     # Start server
sudo systemctl stop vintage-story      # Stop server
sudo systemctl restart vintage-story   # Restart server
sudo systemctl enable vintage-story    # Start on boot
```

### Check Status & Logs
```bash
sudo systemctl status vintage-story    # Check if running
sudo journalctl -u vintage-story -f  # View live logs
sudo journalctl -u vintage-story -e  # View error logs
```

### Memory Monitoring
```bash
# Check memory usage
free -h

# Monitor server process
watch -n 5 'ps aux | grep VintagestoryServer | grep -v grep'
```

## 🌐 Network Setup

### Port Forwarding
- **Port**: 42420 (TCP/UDP)
- **Router**: Forward port 42420 to your server's local IP
- **Firewall**: Already opened by NixOS configuration

### Find Your Public IP
```bash
curl -s ifconfig.me
```

## 🎯 Client Connection

### Add Server in Game
1. Open Vintage Story client
2. Go to Multiplayer → Add new server
3. Enter:
   - **Name**: Simon's Server
   - **IP**: Your public IP address
   - **Password**: (leave empty)
4. Click Create and join!

### Version Requirements
- **Server**: Vintage Story 1.21.5
- **Clients**: Must be exactly 1.21.5
- **Mismatch**: Clients with different versions cannot connect

## ⚠️ Troubleshooting

### Server Won't Start
```bash
# Check logs
sudo journalctl -u vintage-story -n 50

# Check if files exist
ls -la /mnt/drive/vintage-story/VintagestoryServer.exe
ls -la /mnt/drive/vintage-story/data/serverconfig.json
```

### Can't Connect
1. **Check port forwarding**: Ensure port 42420 is open
2. **Check firewall**: NixOS should have opened it
3. **Check whitelist**: Add your username to whitelist
4. **Check versions**: Client must match server (1.21.5)

### Performance Issues
- **3GB RAM** should handle 3-4 players
- **If lagging**: Increase memory in config: `memory = "4G"`
- **Monitor**: Use `free -h` to check memory usage

## 📁 File Locations

- **Server files**: `/mnt/drive/vintage-story/`
- **Config**: `/mnt/drive/vintage-story/data/serverconfig.json`
- **Logs**: `sudo journalctl -u vintage-story`
- **World saves**: `/mnt/drive/vintage-story/data/Saves/`

That's it! Your Vintage Story server should now be running! 🎮