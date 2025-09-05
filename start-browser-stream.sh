#!/bin/bash
# Quick Start für Browser-Stream

echo "🚀 Browser-Stream Quick Start"
echo "============================"

# Check if TCP stream is running
if ! systemctl is-active --quiet birdcam-tcp.service; then
    echo "⚠️  TCP-Stream ist nicht aktiv, starte ihn..."
    sudo systemctl start birdcam-tcp.service
    sleep 3
fi

echo "✅ TCP-Stream läuft"
echo ""

# Start browser stream
echo "🌐 Starte Browser-Stream..."
./scripts/web-stream-v2.sh
