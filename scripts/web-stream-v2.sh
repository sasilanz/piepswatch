#!/bin/bash
# Improved Web Stream Server with better port management

echo "🌐 Starting Piepswatch Web Stream Server"
echo "========================================"

IP=$(hostname -I | awk '{print $1}')
WEB_PORT=8090
STREAM_PORT=8091

# Kill existing servers
echo "🧹 Cleaning up existing servers..."
pkill -f "python.*http.server" 2>/dev/null || true
pkill -f "ffmpeg.*mjpeg" 2>/dev/null || true
sleep 1

# Check if ports are free
if ss -tln | grep -q ":${WEB_PORT} "; then
    echo "❌ Port ${WEB_PORT} still in use, trying ${WEB_PORT}1..."
    WEB_PORT=$((WEB_PORT + 1))
fi

echo ""
echo "📡 Web-Interface wird verfügbar unter:"
echo "   http://${IP}:${WEB_PORT}"
echo ""
echo "📱 Funktioniert direkt im iPhone/iPad Browser!"

# Create a simple stream proxy HTML
cat > /tmp/stream_page.html << 'EOL'
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🐦 Piepswatch Stream</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f0f0;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        h1 { color: #2c3e50; margin-bottom: 20px; }
        .stream {
            width: 100%;
            max-width: 640px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .info {
            background: #e8f4fd;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            font-size: 14px;
        }
        .status {
            padding: 10px;
            border-radius: 6px;
            margin: 15px 0;
            font-weight: bold;
        }
        .online { background: #d4edda; color: #155724; }
        .offline { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐦 Piepswatch Live</h1>
        <div class="status online" id="status">🟢 Stream läuft</div>
        <img class="stream" id="stream" src="STREAM_URL" alt="Live Stream"
             onerror="document.getElementById('status').className='status offline';document.getElementById('status').innerHTML='🔴 Stream offline';">
        
        <div class="info">
            <strong>📱 Mobile Browser Zugriff</strong><br>
            Perfekt für iPhone, iPad, Android Phones/Tablets
        </div>
        
        <div class="info">
            <strong>🎯 Andere URLs:</strong><br>
            VLC App: <code>tcp://REPLACE_IP:8888</code><br>
            Direkt: <a href="STREAM_URL">MJPEG Stream</a>
        </div>
    </div>
    
    <script>
        // Auto-refresh every 30 seconds if stream fails
        setInterval(function() {
            const img = document.getElementById('stream');
            if (img.naturalWidth === 0) {
                img.src = img.src + '?' + new Date().getTime();
            }
        }, 30000);
        
        // Replace IP placeholder
        const ip = window.location.hostname;
        document.body.innerHTML = document.body.innerHTML.replace(/REPLACE_IP/g, ip);
    </script>
</body>
</html>
EOL

# Replace placeholders in HTML
sed -i "s/STREAM_URL/stream.mjpg/g" /tmp/stream_page.html
sed -i "s/REPLACE_IP/${IP}/g" /tmp/stream_page.html

echo ""
echo "🔄 Starting services..."

# Function to cleanup
cleanup() {
    echo ""
    echo "🛑 Stopping all services..."
    kill $WEB_PID 2>/dev/null || true
    kill $STREAM_PID 2>/dev/null || true
    pkill -f "python.*http.server" 2>/dev/null || true
    pkill -f "ffmpeg.*mjpeg" 2>/dev/null || true
    rm -f /tmp/stream_page.html
    exit 0
}

trap cleanup INT TERM

# Start simple HTTP server
cd /tmp
python3 -m http.server $WEB_PORT > /dev/null 2>&1 &
WEB_PID=$!

echo "✅ Web server started on port $WEB_PORT"

# Give web server a moment to start
sleep 2

# Start MJPEG stream
ffmpeg -hide_banner -loglevel quiet \
       -f h264 -i tcp://127.0.0.1:8888 \
       -f mjpeg -q:v 4 -r 5 \
       -content_type image/jpeg \
       -listen 1 \
       -f mjpeg \
       http://0.0.0.0:${WEB_PORT}/stream.mjpeg 2>/dev/null &

STREAM_PID=$!

echo "✅ MJPEG stream started"
echo ""
echo "🎯 Ready! Open in any browser:"
echo "   http://${IP}:${WEB_PORT}"
echo ""
echo "💡 Works great on iPhone/iPad Safari!"
echo ""
echo "Press Ctrl+C to stop"

# Wait for processes
wait $WEB_PID
