# 📚 Piepswatch - IT-Kurs Networking Tutorial

Dieses Raspberry Pi System dient als praktisches Beispiel für Netzwerk-Konfiguration und IoT-Streaming im Senioren-IT-Kurs.

## 🎯 Lernziele

- **WLAN-Konfiguration** mit verschiedenen Netzwerken
- **Netzwerk-Troubleshooting** und Diagnostik
- **TCP/IP Grundlagen** am praktischen Beispiel
- **IoT-Streaming** verstehen und einrichten

## 📋 Kurs-Vorbereitung (für Lehrer)

### 1. WLAN-Profile vorbereiten
```bash
# Interaktives WLAN-Setup-Tool starten
sudo ./scripts/wifi-setup.sh

# Optionen:
# 3) Add new WiFi network - Schulungs-WLAN hinzufügen
# 1) Show current WiFi status - Status prüfen
```

### 2. Backup-Verbindungsmöglichkeiten

**Option A: Hotspot-Modus** (empfohlen)
```bash
# Pi als WLAN-Hotspot verwenden
sudo ./scripts/wifi-setup.sh
# Wähle Option 5: Create WiFi hotspot

# Netzwerk: Piepswatch-Demo
# Passwort: piepswatch123
# Pi IP: 10.42.0.1
```

**Option B: USB-Ethernet** (für Notfälle)
```bash
# USB-Ethernet aktivieren (einmalig)
sudo ./scripts/usb-ethernet-setup.sh
# Dann reboot und USB-Kabel verwenden
```

## 👥 Kurs-Ablauf

### Phase 1: Netzwerk verstehen (15 min)
```bash
# 1. Aktuelle Netzwerk-Info anzeigen
hostname -I
iwconfig
nmcli connection show

# 2. Verfügbare WLANs scannen  
nmcli device wifi list

# 3. Netzwerk-Details verstehen
ip route show
cat /etc/resolv.conf
```

### Phase 2: WLAN-Konfiguration (20 min)
```bash
# Interaktives Tool für WLAN-Setup
sudo ./scripts/wifi-setup.sh

# Übungen:
# - Neues WLAN hinzufügen
# - Zwischen WLANs wechseln
# - Prioritäten verstehen
# - Troubleshooting bei Verbindungsproblemen
```

### Phase 3: Streaming verstehen (15 min)
```bash
# 1. Camera Stream starten
sudo systemctl start birdcam-tcp.service
sudo systemctl status birdcam-tcp.service

# 2. Netzwerk-Ports verstehen
ss -tlnp | grep 8888
netstat -an | grep 8888

# 3. Stream testen (von anderem Gerät)
ffplay tcp://[PI-IP]:8888
# oder mit VLC: tcp://[PI-IP]:8888
```

### Phase 4: Troubleshooting (10 min)
```bash
# Häufige Probleme und Lösungen:

# 1. Kein Internet
ping 8.8.8.8
nslookup google.com

# 2. WLAN-Probleme  
nmcli device wifi rescan
nmcli connection show
nmcli connection up [name]

# 3. Stream-Probleme
journalctl -u birdcam-tcp.service -f
ps aux | grep rpicam
```

## 🛠 Praktische Übungen

### Übung 1: WLAN wechseln
1. Aktuelles WLAN anzeigen
2. Verfügbare WLANs scannen
3. Zu anderem WLAN wechseln
4. IP-Adresse-Änderung beobachten

### Übung 2: Netzwerk-Diagnose
1. `ping` zum Router
2. `ping` ins Internet
3. DNS-Auflösung testen
4. Geschwindigkeit messen

### Übung 3: IoT-Stream einrichten
1. Stream starten
2. IP-Adresse finden
3. Von Smartphone/Tablet darauf zugreifen
4. Netzwerk-Traffic analysieren

## 🎓 Erweiterte Themen

### Für Fortgeschrittene:
- **Port-Forwarding** für externen Zugriff
- **VPN-Setup** für sicheren Remote-Zugang  
- **Firewall-Konfiguration** mit UFW
- **Monitoring** mit Tools wie htop, iftop

### Hausaufgaben:
- Eigenes WLAN zu Hause hinzufügen
- Stream von außerhalb des Netzwerks testen
- YouTube-Integration ausprobieren

## 🚨 Troubleshooting-Guide

| Problem | Lösung |
|---------|--------|
| Kein WLAN sichtbar | `sudo nmcli device wifi rescan` |
| Verbindung schlägt fehl | Passwort prüfen, Signal-Stärke checken |
| Kein Internet | DNS-Server prüfen, Router neustarten |
| Stream nicht erreichbar | Firewall prüfen, Port 8888 freigeben |
| Pi nicht erreichbar | IP-Adresse prüfen, SSH-Service starten |

## 📞 Notfall-Zugriff

Falls das Pi nicht über WLAN erreichbar ist:

### Option 1: Hotspot-Modus
```bash
# Bei direktem Zugriff zum Pi:
sudo ./scripts/wifi-setup.sh
# Option 5 wählen

# Dann mit Laptop/Phone verbinden:
# SSID: Piepswatch-Demo
# Password: piepswatch123
# Pi erreichbar unter: 10.42.0.1
```

### Option 2: USB-Ethernet  
1. USB-Kabel zwischen Pi und Mac verbinden
2. Pi erscheint als Netzwerk-Interface
3. Link-local IP (169.254.x.x) verwenden
4. `arp -a` auf Mac um Pi-IP zu finden

### Option 3: HDMI + Tastatur
- Monitor und Tastatur direkt am Pi anschließen
- Direkte Konfiguration über Terminal

## 🏁 Abschluss-Checkliste

- [ ] Teilnehmer können WLAN scannen und verbinden
- [ ] IP-Adressen und Netzwerk-Grundlagen verstanden
- [ ] Stream erfolgreich eingerichtet und getestet
- [ ] Troubleshooting-Methoden bekannt
- [ ] Sicherheitsaspekte besprochen (WPA2, Passwörter)

---

**💡 Tipp für Kursleiter:** 
Bereite mehrere WLAN-Hotspots vor (Handy, MiFi) falls das Schulungs-WLAN Probleme macht. Das Pi kann schnell zwischen verschiedenen Netzwerken wechseln!
