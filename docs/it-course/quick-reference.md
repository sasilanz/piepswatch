# 🚀 Piepswatch IT-Kurs - Schnellreferenz

## Wichtige Befehle

### Netzwerk-Status prüfen
```bash
hostname -I                    # IP-Adresse anzeigen
iwconfig                      # WLAN-Status
nmcli connection show         # Alle Verbindungen
nmcli device wifi list       # Verfügbare WLANs scannen
```

### WLAN konfigurieren  
```bash
sudo ./scripts/wifi-setup.sh  # Interaktives WLAN-Tool
nmcli device wifi rescan      # Netzwerke neu scannen
```

### Camera Stream
```bash
sudo systemctl start birdcam-tcp.service   # Stream starten
sudo systemctl stop birdcam-tcp.service    # Stream stoppen
sudo systemctl status birdcam-tcp.service  # Status prüfen
journalctl -u birdcam-tcp.service -f       # Live-Logs anzeigen
```

### Troubleshooting
```bash
ping 8.8.8.8                 # Internet-Verbindung testen
ping 192.168.1.1             # Router erreichen
nslookup google.com          # DNS-Auflösung testen
ss -tlnp | grep 8888         # Port 8888 prüfen
```

## Notfall-Zugriff

### Hotspot aktivieren
```bash
sudo ./scripts/wifi-setup.sh
# Option 5: Create WiFi hotspot
# SSID: Piepswatch-Demo
# Password: piepswatch123
# Pi IP: 10.42.0.1
```

### Vom Mac/PC zugreifen
```bash
# Stream anschauen:
ffplay tcp://192.168.1.169:8888
# oder in VLC: tcp://192.168.1.169:8888

# SSH-Verbindung:
ssh emily@192.168.1.169
```

## IP-Adressen merken

- **Zu Hause**: 192.168.1.169
- **Hotspot-Modus**: 10.42.0.1  
- **USB-Ethernet**: 169.254.x.x
- **Schulungs-WLAN**: [wird im Kurs ermittelt]

## Wichtige Ports

- **8888**: Camera TCP Stream
- **22**: SSH-Zugriff
- **8888**: Kamera-Stream

## Häufige Probleme

| Problem | Schnelle Lösung |
|---------|----------------|
| Kein Internet | `ping 8.8.8.8` dann Router neustarten |
| WLAN weg | `sudo nmcli device wifi rescan` |
| Stream läuft nicht | `sudo systemctl restart birdcam-tcp.service` |
| Pi nicht erreichbar | Hotspot-Modus aktivieren |
