#!/bin/bash
# Quick Start für Browser-Stream

SCRIPT_DIR="$(dirname "$0")"
cd "$(dirname "$SCRIPT_DIR")"  # Go to project root

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
