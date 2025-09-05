# 📱 Piepswatch - Bedienungsanleitung

## 🚀 Schnellstart

**Der neue TCP-Service startet automatisch beim Einschalten des Pi!**

### Stream anschauen:
```bash
# Vom Mac/PC:
ffplay tcp://192.168.1.169:8888

# Oder in VLC:
# Datei → Netzwerk öffnen → tcp://192.168.1.169:8888
```

### IP-Adresse herausfinden:
```bash
hostname -I
# Oder auf dem Pi:
./scripts/wifi-setup.sh  # Option 1: Show current WiFi status
```

## ⚙️ Service-Verwaltung

```bash
# Status prüfen
sudo systemctl status birdcam-tcp.service

# Stream starten (falls gestoppt)
sudo systemctl start birdcam-tcp.service  

# Stream stoppen
sudo systemctl stop birdcam-tcp.service

# Stream neustarten
sudo systemctl restart birdcam-tcp.service

# Live-Logs anzeigen
journalctl -u birdcam-tcp.service -f
```

## 🌐 Netzwerk-Konfiguration 

### Für den IT-Kurs / andere WLANs:
```bash
# Interaktives WLAN-Tool starten
sudo ./scripts/wifi-setup.sh

# Optionen:
# 1) WiFi-Status anzeigen
# 2) Verfügbare Netzwerke scannen  
# 3) Neues WLAN hinzufügen
# 4) Zu anderem WLAN wechseln
# 5) Hotspot-Modus (für Demos ohne WLAN)
```

### Hotspot-Modus (Notfall):
```bash
sudo ./scripts/wifi-setup.sh
# Option 5 wählen

# Dann mit anderen Geräten verbinden:
# WLAN: "Piepswatch-Demo"
# Passwort: "piepswatch123"
# Stream: tcp://10.42.0.1:8888
```

## 📺 YouTube-Streaming

```bash
# 1. YouTube Stream-Key eintragen
cp config/youtube-key.txt.template config/youtube-key.txt
nano config/youtube-key.txt  # Deinen Key einfügen

# 2. YouTube-Stream starten (vom Mac/PC mit ffmpeg)
./scripts/youtube-stream.sh
```

## 🔧 Troubleshooting

### Stream funktioniert nicht:
```bash
# Service-Status prüfen
sudo systemctl status birdcam-tcp.service

# Service neustarten  
sudo systemctl restart birdcam-tcp.service

# Kamera testen
rpicam-vid -t 5000 --width 640 --height 480 --inline -o /dev/null
```

### Netzwerk-Probleme:
```bash
# Internet-Verbindung testen
ping 8.8.8.8

# WLAN neu scannen
nmcli device wifi rescan

# IP-Adresse prüfen
hostname -I
iwconfig
```

### Port blockiert:
```bash
# Port 8888 prüfen
ss -tlnp | grep 8888

# Andere rpicam-Prozesse beenden
sudo pkill rpicam-vid
sudo systemctl restart birdcam-tcp.service
```

## 📍 Wichtige Adressen

| Situation | IP-Adresse | Stream-URL |
|-----------|------------|------------|
| Zu Hause (Welan_OG) | 192.168.1.169 | `tcp://192.168.1.169:8888` |
| Hotspot-Modus | 10.42.0.1 | `tcp://10.42.0.1:8888` |
| USB-Ethernet | 169.254.x.x | `tcp://169.254.x.x:8888` |
| Schulungs-WLAN | [variable] | `tcp://[IP]:8888` |

## 🎓 Für den IT-Kurs

Siehe auch: [docs/it-course/README.md](docs/it-course/README.md)

**Kurs-Tools:**
- `sudo ./scripts/wifi-setup.sh` - WLAN-Konfiguration
- `sudo ./scripts/usb-ethernet-setup.sh` - USB-Ethernet Backup  
- [docs/it-course/quick-reference.md](docs/it-course/quick-reference.md) - Schnellreferenz für Teilnehmer

---

## ✅ Migration abgeschlossen!

**Was geändert wurde:**
- ❌ Alter RTSP-Service (emily-stream.service) → gestoppt & deaktiviert
- ✅ Neuer TCP-Service (birdcam-tcp.service) → aktiv & auto-start
- 🔄 Stream-URL: `rtsp://192.168.1.169:8554/emily` → `tcp://192.168.1.169:8888`

**Vorteile des neuen Systems:**
- 🚀 Stabiler und einfacher  
- 🔧 Bessere Kompatibilität
- 📱 Einfacher zu verwenden
- 🌐 Flexible Netzwerk-Tools

## 📱 Browser-Zugriff (iPhone/iPad/Android)

**Problem**: TCP-Links funktionieren nicht im Browser!
**Lösung**: HTTP-Web-Interface verwenden

### Für Browser (Safari, Chrome, etc.):
```bash
# 1. Web-Server starten (zusätzlich zum TCP-Stream)
./scripts/web-stream.sh

# 2. Im Browser öffnen:  
http://192.168.1.169:8090
```

### Browser-URLs:
| Gerät | URL |
|-------|-----|
| **Zu Hause** | http://192.168.1.169:8090 |
| **Hotspot** | http://10.42.0.1:8090 |  
| **Schulung** | http://[PI-IP]:8090 |

### Mobile Apps (empfohlen für beste Qualität):
- **iPhone/iPad**: VLC App (kostenlos)
  - URL: `tcp://192.168.1.169:8888`
- **Android**: VLC App oder MX Player

## 🔄 Beide Streams parallel

Du kannst beide gleichzeitig nutzen:
- **TCP-Stream**: Läuft automatisch (Port 8888) - für VLC Apps
- **Web-Stream**: Startest du manuell (Port 8090) - für Browser

```bash
# TCP-Stream (läuft automatisch):
systemctl status birdcam-tcp.service

# Web-Stream zusätzlich starten:
./scripts/web-stream.sh
```

## 📊 Stream-Vergleich

| Stream-Typ | Qualität | Latenz | Geräte |
|------------|----------|---------|--------|
| **TCP** | Hoch | Niedrig | VLC Apps |
| **HTTP/Browser** | Mittel | Höher | Alle Browser |

**Empfehlung**: 
- **VLC App** für beste Qualität
- **Browser** für schnellen Zugriff ohne App

## 🚀 Schnellstart Browser-Stream

**Einfachster Weg für iPhone/Browser:**
```bash
./scripts/start-browser-stream.sh
```

**URLs aktualisiert (Port 8090 statt 8080):**
- Zu Hause: `http://192.168.1.169:8090`
- Hotspot: `http://10.42.0.1:8090`
- Schulung: `http://[PI-IP]:8090`

Das Script:
✅ Prüft ob TCP-Stream läuft
✅ Startet Browser-Stream automatisch  
✅ Verwendet freie Ports (8090)
✅ Zeigt alle URLs an
