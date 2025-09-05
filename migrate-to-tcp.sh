#!/bin/bash
# Migration von RTSP-Service zu TCP-Service

echo "🔄 Piepswatch Migration: RTSP → TCP"
echo "=================================="

echo ""
echo "📊 Aktueller Status:"
echo "-------------------"
systemctl is-active emily-stream.service && echo "✅ Alter RTSP-Service läuft"
systemctl is-enabled emily-stream.service && echo "✅ Alter Service ist auto-start aktiviert"

echo ""
echo "🛑 Stoppe alten RTSP-Service..."
sudo systemctl stop emily-stream.service
sudo systemctl disable emily-stream.service

echo ""  
echo "⚙️ Installiere neuen TCP-Service..."
sudo cp config/birdcam-tcp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable birdcam-tcp.service

echo ""
echo "🚀 Starte neuen TCP-Service..."
sudo systemctl start birdcam-tcp.service

echo ""
echo "📊 Neuer Status:"
echo "---------------"
sudo systemctl status birdcam-tcp.service --no-pager -l

echo ""
echo "📡 Netzwerk-Info:"
echo "----------------"
echo "IP-Adresse: $(hostname -I | awk '{print $1}')"
echo "TCP-Stream: tcp://$(hostname -I | awk '{print $1}'):8888"
echo ""

echo "✅ Migration abgeschlossen!"
echo ""
echo "🎯 Testen mit:"
echo "ffplay tcp://$(hostname -I | awk '{print $1}'):8888"
echo ""
echo "📝 Service-Befehle:"
echo "sudo systemctl start birdcam-tcp.service    # Starten"
echo "sudo systemctl stop birdcam-tcp.service     # Stoppen" 
echo "sudo systemctl status birdcam-tcp.service   # Status"
echo "sudo systemctl restart birdcam-tcp.service  # Neustarten"
