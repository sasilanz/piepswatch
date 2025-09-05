#!/bin/bash
# HTTP-Stream Server für Browser-Zugriff
# Läuft parallel zum TCP-Stream

echo "🌐 Starting HTTP Stream Server für Browser..."
echo "============================================="

echo "📡 Browser-Stream wird verfügbar unter:"
echo "http://$(hostname -I | awk '{print $1}'):8080/stream.mjpg"
echo ""
echo "Für iPhone Safari, Chrome, etc."
echo "Press Ctrl+C to stop"

# HTTP-Server mit FFmpeg für MJPEG Stream
ffmpeg -f h264 -i tcp://127.0.0.1:8888 \
       -f mjpeg \
       -q:v 3 \
       -r 10 \
       -listen 1 \
       -f mjpeg \
       http://0.0.0.0:8080/stream.mjpg
