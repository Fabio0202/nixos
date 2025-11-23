#!/usr/bin/env bash

# Vintage Story Server Monitor
# Monitors server performance and resource usage

VS_DIR="/mnt/drive/vintage-story"
LOG_FILE="/tmp/vs-monitor.log"

echo "=== Vintage Story Server Monitor ==="
echo "Press Ctrl+C to stop monitoring"
echo "Logs saved to: $LOG_FILE"
echo ""

# Function to get server PID
get_vs_pid() {
    pgrep -f "VintagestoryServer.exe" | head -1
}

# Function to get memory usage in MB
get_memory_usage() {
    local pid=$1
    if [ -n "$pid" ]; then
        ps -p "$pid" -o rss= | awk '{print $1/1024 " MB"}'
    else
        echo "Server not running"
    fi
}

# Function to get system memory
get_system_memory() {
    free -h | grep "Mem:" | awk '{print "Used: " $3 " / " $2 " (" int($3/$2 * 100) "%)"}'
}

# Monitor loop
while true; do
    clear
    echo "=== Vintage Story Server Monitor ==="
    echo "Time: $(date)"
    echo ""
    
    # Server status
    PID=$(get_vs_pid)
    if [ -n "$PID" ]; then
        echo "✅ Server Status: RUNNING (PID: $PID)"
        echo "📊 Server Memory: $(get_memory_usage $PID)"
    else
        echo "❌ Server Status: NOT RUNNING"
    fi
    
    echo "💾 System Memory: $(get_system_memory)"
    
    # Check for OOM errors in logs
    if sudo journalctl -u vintage-story --since "1 hour ago" | grep -qi "out of memory\|oom\|killed"; then
        echo "⚠️  WARNING: Out of memory errors detected in last hour!"
    fi
    
    # Server logs (last 5 lines)
    echo ""
    echo "📝 Recent Server Logs:"
    sudo journalctl -u vintage-story --no-pager -n 5 --since "5 minutes ago" | tail -5
    
    echo ""
    echo "=== Performance Tips ==="
    echo "• If memory > 2.5GB consistently, consider increasing to 4G"
    echo "• If server crashes, check: sudo journalctl -u vintage-story -e"
    echo "• To restart: sudo systemctl restart vintage-story"
    
    # Log to file
    echo "$(date): PID=$PID, Memory=$(get_memory_usage $PID), System=$(get_system_memory)" >> "$LOG_FILE"
    
    sleep 10
done