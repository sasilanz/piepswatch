#!/bin/bash
# HTTPS Web Stream für Safari-Kompatibilität

echo "🔒 Starting HTTPS Stream Server für Safari"
echo "========================================="

IP=$(hostname -I | awk '{print $1}')
HTTPS_PORT=8443

# Kill existing servers
echo "🧹 Cleaning up existing servers..."
pkill -f "python.*http.server" 2>/dev/null || true
pkill -f "openssl.*s_server" 2>/dev/null || true
sleep 1

echo ""
echo "🔐 Erstelle temporäres SSL-Zertifikat..."

# Create temporary SSL certificate
openssl req -x509 -newkey rsa:2048 -keyout /tmp/server.key -out /tmp/server.crt -days 1 -nodes -subj "/CN=${IP}" 2>/dev/null

# Create simple HTML page
cat > /tmp/https_stream.html << EOL
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🐦 Piepswatch HTTPS Stream</title>
    <style>
        body {
            margin: 0; padding: 20px;
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f0f0; text-align: center;
        }
        .container {
            max-width: 800px; margin: 0 auto;
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        h1 { color: #2c3e50; }
        .stream { width: 100%; max-width: 640px; border-radius: 8px; }
        .info { background: #e8f4fd; padding: 15px; border-radius: 8px; margin: 20px 0; }
        .warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 8px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐦 Piepswatch HTTPS Stream</h1>
        
        <div class="warning">
            <strong>⚠️ Safari Warnung:</strong><br>
            Safari zeigt "Nicht sicher" - das ist normal!<br>
            Klicke "Trotzdem besuchen" oder "Advanced → Proceed"
        </div>
        
        <img class="stream" src="/stream.mjpg" alt="Live Stream">
        
        <div class="info">
            <strong>📱 Funktioniert mit Safari HTTPS</strong><br>
            Selbst-signiertes Zertifikat für lokale Nutzung
        </div>
        
        <div class="info">
            <strong>🎯 Alternativen:</strong><br>
            • Chrome/Firefox: http://${IP}:8090<br>
            • VLC App: tcp://${IP}:8888
        </div>
    </div>
</body>
</html>
EOL

echo ""
echo "📡 HTTPS-Server wird verfügbar unter:"
echo "   https://${IP}:${HTTPS_PORT}"
echo ""
echo "⚠️  Safari zeigt 'Nicht sicher' - das ist normal!"
echo "    Klicke 'Erweitert' → 'Trotzdem fortfahren'"

# Function to cleanup
cleanup() {
    echo ""
    echo "🛑 Stopping HTTPS services..."
    kill $HTTPS_PID 2>/dev/null || true
    kill $STREAM_PID 2>/dev/null || true
    pkill -f "openssl.*s_server" 2>/dev/null || true
    rm -f /tmp/server.key /tmp/server.crt /tmp/https_stream.html
    exit 0
}

trap cleanup INT TERM

# Start HTTPS server with OpenSSL
cd /tmp
openssl s_server -key server.key -cert server.crt -port $HTTPS_PORT -HTTP &
HTTPS_PID=$!

echo "✅ HTTPS Server gestartet"

# Start MJPEG stream
ffmpeg -hide_banner -loglevel quiet \
       -f h264 -i tcp://127.0.0.1:8888 \
       -f mjpeg -q:v 4 -r 5 \
       -listen 1 -f mjpeg \
       http://0.0.0.0:${HTTPS_PORT}/stream.mjpg 2>/dev/null &

STREAM_PID=$!

echo "✅ MJPEG Stream gestartet"
echo ""
echo "🎯 Safari öffnen:"
echo "   https://${IP}:${HTTPS_PORT}"
echo ""
echo "💡 Bei 'Nicht sicher' Warnung:"
echo "   Erweitert → Trotzdem fortfahren"
echo ""
echo "Press Ctrl+C to stop"

wait
