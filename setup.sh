#!/bin/bash
# Piepswatch Bird Camera - Setup Script
# Installs and configures the bird camera system

set -e

echo "🐦 Piepswatch Bird Camera Setup"
echo "==============================="
echo ""

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Warning: This doesn't appear to be a Raspberry Pi"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "📦 Installing dependencies..."

# Update package list
sudo apt update

# Install required packages
sudo apt install -y ffmpeg

# Check if camera is detected
echo ""
echo "🎥 Checking camera..."
if ! command -v rpicam-vid &> /dev/null; then
    echo "❌ rpicam-vid not found. Please ensure camera support is enabled."
    echo "   Run: sudo raspi-config -> Interface Options -> Camera -> Enable"
    exit 1
fi

# Test camera briefly
echo "Testing camera (5 second test)..."
timeout 5s rpicam-vid -t 5000 --width 640 --height 480 --inline -o /dev/null || {
    echo "❌ Camera test failed. Please check camera connection and configuration."
    exit 1
}

echo "✅ Camera test successful!"

# Install systemd service
echo ""
echo "⚙️ Installing systemd service..."

# Stop existing service if it exists  
sudo systemctl stop emily-stream.service 2>/dev/null || true
sudo systemctl disable emily-stream.service 2>/dev/null || true

# Install new service
sudo cp config/birdcam-tcp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable birdcam-tcp.service

# Update service file with correct path
sudo sed -i "s|/home/emily/piepswatch-birdcam|$(pwd)|g" /etc/systemd/system/birdcam-tcp.service

echo ""
echo "🚀 Setup complete!"
echo ""
echo "Available commands:"
echo "  Start stream:    sudo systemctl start birdcam-tcp.service"
echo "  Stop stream:     sudo systemctl stop birdcam-tcp.service"
echo "  View status:     systemctl status birdcam-tcp.service"
echo "  View logs:       journalctl -u birdcam-tcp.service -f"
echo ""
echo "Local viewing:"
echo "  Stream URL:      tcp://$(hostname -I | awk '{print $1}'):8888"
echo "  View with:       ffplay tcp://$(hostname -I | awk '{print $1}'):8888"
echo ""
echo "For YouTube streaming:"
echo "  1. Copy config/youtube-key.txt.template to config/youtube-key.txt"
echo "  2. Add your YouTube stream key to the file"
echo "  3. Run: ./scripts/youtube-stream.sh"
echo ""
read -p "Start the camera stream now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo systemctl start birdcam-tcp.service
    echo "✅ Stream started! Check status with: systemctl status birdcam-tcp.service"
fi
