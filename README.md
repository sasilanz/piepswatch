# 🐦 Piepswatch - Bird Camera Live Stream

Simple and reliable Raspberry Pi bird camera with RTSP streaming that works on **all devices**.

## 🚀 Quick Start

**Stream is automatically running!** Just open in any app:

```
rtsp://192.168.1.169:8554/emily
```

## 📱 How to View

### iPhone/iPad
- Install **VLC App** (free from App Store)
- Open Network Stream: `rtsp://192.168.1.169:8554/emily`

### Android  
- Install **VLC App** or **MX Player**
- Open Network Stream: `rtsp://192.168.1.169:8554/emily`

### Mac/PC
- **VLC Player**: Open Network Stream
- **QuickTime**: File → Open Location
- **Any RTSP-capable app**

## ⚙️ Control

```bash
# Check status
sudo systemctl status emily-stream.service

# Restart if needed  
sudo systemctl restart emily-stream.service

# View logs
journalctl -u emily-stream.service -f
```

## 🌐 Network Setup

For different WiFi networks (IT courses, etc.):

```bash
sudo ./scripts/wifi-setup.sh
```

**Stream URLs for different networks:**
- Home: `rtsp://192.168.1.169:8554/emily`
- Hotspot: `rtsp://10.42.0.1:8554/emily` 
- Course: `rtsp://[PI-IP]:8554/emily`

## 📺 YouTube Streaming

Stream to YouTube Live from Mac/PC:

```bash
# 1. Add your YouTube stream key
cp config/youtube-key.txt.template config/youtube-key.txt
# Edit the file with your key

# 2. Start YouTube stream
./scripts/youtube-stream.sh
```

## 🔧 Installation

```bash
git clone https://github.com/sasilanz/piepswatch.git
cd piepswatch
./setup.sh
```

## 🎓 IT Course Ready

Perfect for teaching networking concepts:
- RTSP protocol understanding
- Network troubleshooting  
- Multiple WiFi configurations
- Cross-device compatibility

See [IT Course Documentation](docs/it-course/) for detailed lesson plans.

## 📋 Technical Details

- **Protocol**: RTSP (Real Time Streaming Protocol)
- **Format**: H.264 video stream
- **Resolution**: 640x480 @ 30fps
- **Latency**: < 1 second (true live streaming)
- **Compatibility**: All major devices and apps

## 🏠 Network Addresses

| Network | IP | Stream URL |
|---------|----|-----------| 
| Home WiFi | 192.168.1.169 | `rtsp://192.168.1.169:8554/emily` |
| Hotspot | 10.42.0.1 | `rtsp://10.42.0.1:8554/emily` |
| Course WiFi | [variable] | `rtsp://[PI-IP]:8554/emily` |

## 🛠 Troubleshooting

**Stream not working?**
```bash
sudo systemctl restart emily-stream.service
```

**Wrong IP address?**
```bash
hostname -I  # Get current IP
```

**Network issues?**
```bash
sudo ./scripts/wifi-setup.sh  # Switch networks
```

---

**Created by**: Astrid Lanz, 2025  
**Purpose**: Bird watching and IT education  
**Tech**: RTSP streaming - simple and reliable! 🎥✨
