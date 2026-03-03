#!/bin/bash
# Piepswatch YouTube Live Stream Service

YOUTUBE_KEY_FILE="/home/emily/piepswatch-birdcam/config/youtube-key.txt"
RTSP_URL="rtsp://localhost:8554/emily"

YOUTUBE_KEY=$(cat "$YOUTUBE_KEY_FILE")

exec ffmpeg -hide_banner -loglevel warning \
     -fflags +genpts \
     -rtsp_transport udp \
     -i "$RTSP_URL" \
     -f lavfi -i anullsrc=r=44100:cl=stereo \
     -shortest -c:v copy -c:a aac -b:a 128k \
     -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY"
