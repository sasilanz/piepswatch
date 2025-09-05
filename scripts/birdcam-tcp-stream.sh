#!/bin/bash
# Piepswatch Bird Camera - TCP Stream
# Starts the camera stream via TCP on port 8888

echo "Starting Piepswatch Bird Camera TCP Stream..."
echo "Stream will be available at: tcp://$(hostname -I | awk '{print $1}'):8888"
echo "View with: ffplay -i tcp://$(hostname -I | awk '{print $1}'):8888"
echo ""
echo "Press Ctrl+C to stop the stream"

# Start the camera stream
rpicam-vid -t 0 --width 640 --height 480 --inline --listen -o tcp://0.0.0.0:8888
