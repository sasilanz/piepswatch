# 🐦 Piepswatch - Bird Camera Streaming System

A simple and reliable Raspberry Pi camera streaming solution for bird watching, featuring local TCP streaming and YouTube Live integration.

## Features

- 📹 **TCP Stream**: Direct camera access via TCP (port 8888)
- 📺 **YouTube Live**: Stream to YouTube for remote viewing
- ⚡ **Auto-start**: Systemd service for automatic startup
- 🔧 **Simple Setup**: One-script installation

## Quick Start

1. **Clone and install**:
   ```bash
   git clone https://github.com/sasilanz/piepswatch.git
   cd piepswatch-birdcam
   ./setup.sh
   ```

2. **View locally**:
   ```bash
   ffplay tcp://192.168.1.169:8888
   ```

3. **Stream to YouTube** (optional):
   ```bash
   # Setup YouTube key first
   cp config/youtube-key.txt.template config/youtube-key.txt
   # Edit the file and add your YouTube stream key
   
   # Start YouTube streaming (run from Mac/PC with ffmpeg)
   ./scripts/youtube-stream.sh
   ```

## System Requirements

- Raspberry Pi with camera module
- Raspbian OS with camera support enabled
- Network connection

## Directory Structure

```
piepswatch-birdcam/
├── scripts/
│   ├── birdcam-tcp-stream.sh    # Main camera TCP stream script
│   └── youtube-stream.sh        # YouTube streaming script
├── config/
│   ├── birdcam-tcp.service      # Systemd service configuration
│   └── youtube-key.txt.template # YouTube key template
├── setup.sh                     # Automated installation script
└── README.md                    # This file
```

## Usage

### Manual Control
```bash
# Start the stream
sudo systemctl start birdcam-tcp.service

# Stop the stream  
sudo systemctl stop birdcam-tcp.service

# Check status
systemctl status birdcam-tcp.service

# View logs
journalctl -u birdcam-tcp.service -f
```

### Local Viewing
- **Stream URL**: `tcp://[PI-IP]:8888`
- **FFplay**: `ffplay tcp://192.168.1.169:8888`
- **VLC**: Open network stream with the TCP URL

### YouTube Streaming
1. Get your stream key from [YouTube Studio](https://studio.youtube.com)
2. Create `config/youtube-key.txt` with your key
3. Run `./scripts/youtube-stream.sh` from a device with ffmpeg

## Technical Details

- **Resolution**: 640x480 (configurable in scripts)
- **Format**: H.264 video stream
- **Protocol**: TCP for local, RTMP for YouTube
- **Service**: Auto-restart on failure with 5-second delay

## Troubleshooting

### Camera Issues
```bash
# Test camera
rpicam-vid -t 5000 --width 640 --height 480 --inline -o /dev/null

# Enable camera (if needed)
sudo raspi-config
# -> Interface Options -> Camera -> Enable
```

### Network Issues
```bash
# Check Pi IP address
hostname -I

# Test TCP connection
telnet 192.168.1.169 8888
```

### Service Issues
```bash
# Restart service
sudo systemctl restart birdcam-tcp.service

# Full service reload
sudo systemctl daemon-reload
sudo systemctl restart birdcam-tcp.service
```

## Configuration

Edit scripts to customize:
- **Resolution**: Change `--width` and `--height` parameters
- **Port**: Change `8888` to desired port
- **Quality**: Add encoding parameters to rpicam-vid

## License

MIT License - Feel free to use for your own bird watching projects!

---

**Created by**: Astrid Lanz, 2025  
**Hardware**: Raspberry Pi + Camera Module  
**Purpose**: Bird watching and nature observation
