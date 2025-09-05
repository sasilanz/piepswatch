#!/bin/bash
# Combined HTTP Web Server + MJPEG Stream für Browser-Zugriff

echo "🌐 Starting Web Stream Server..."
echo "==============================="

# Kill existing python servers
pkill -f "python.*http.server" 2>/dev/null || true

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "📡 Web-Interface verfügbar unter:"
echo "   http://${IP}:8080"
echo ""
echo "📱 Perfekt für iPhone, iPad, Android - direkt im Browser!"
echo ""
echo "Press Ctrl+C to stop all services"

# Start HTTP file server in background
cd web
python3 -m http.server 8080 &
HTTP_PID=$!
cd ..

echo "✅ Web-Server gestartet (PID: $HTTP_PID)"

# Function to cleanup
cleanup() {
    echo ""
    echo "🛑 Stopping services..."
    kill $HTTP_PID 2>/dev/null || true
    pkill -f "python.*http.server" 2>/dev/null || true
    exit 0
}

# Set trap for cleanup
trap cleanup INT TERM

echo "🔄 Starting MJPEG stream relay..."
echo "   Converting TCP → HTTP for browsers..."

# Start MJPEG relay
ffmpeg -hide_banner -loglevel error \
       -f h264 -i tcp://127.0.0.1:8888 \
       -f mjpeg -q:v 5 -r 8 \
       -f mjpeg -listen 1 \
       -content_type image/jpeg \
       http://0.0.0.0:8080/stream.mjpg &

FFMPEG_PID=$!

echo "✅ MJPEG relay gestartet (PID: $FFMPEG_PID)"
echo ""
echo "🎯 URLs:"
echo "   Website:      http://${IP}:8080"
echo "   Direct MJPEG: http://${IP}:8080/stream.mjpg"
echo "   VLC (TCP):    tcp://${IP}:8888"

# Wait for both processes
wait
