#!/bin/bash
# Piepswatch Bird Camera - YouTube Live Stream
# Streams the RTSP camera feed to YouTube Live

# Configuration
PI_IP="${PI_IP:-192.168.1.169}"
YOUTUBE_KEY_FILE="${YOUTUBE_KEY_FILE:-config/youtube-key.txt}"

# Check if YouTube key file exists
if [ ! -f "$YOUTUBE_KEY_FILE" ]; then
    echo "Error: YouTube stream key file not found: $YOUTUBE_KEY_FILE"
    echo "Please create the file with your YouTube stream key."
    echo "Get your key from: https://studio.youtube.com/channel/YOUR_CHANNEL/videos/upload"
    exit 1
fi

# Read YouTube stream key
YOUTUBE_KEY=$(cat "$YOUTUBE_KEY_FILE")

if [ -z "$YOUTUBE_KEY" ]; then
    echo "Error: YouTube stream key is empty"
    exit 1
fi

echo "📺 Starting YouTube Live Stream..."
echo "📡 Pi Camera RTSP: rtsp://$PI_IP:8554/emily"
echo "🎬 YouTube RTMP: rtmp://a.rtmp.youtube.com/live2/[HIDDEN]"
echo ""
echo "Press Ctrl+C to stop streaming"

# Start FFmpeg streaming from RTSP to YouTube
ffmpeg -hide_banner \
       -rtsp_transport udp \
       -i rtsp://$PI_IP:8554/emily \
       -f lavfi -i anullsrc=r=44100:cl=stereo \
       -shortest -c:v copy -c:a aac -b:a 128k \
       -f flv rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY
