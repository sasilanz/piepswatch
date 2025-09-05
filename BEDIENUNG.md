# 📱 Piepswatch - Super Einfache Bedienung

## 🚀 Schnellstart  

**Der Stream läuft automatisch!** 

### Für iPhone/iPad:
1. **VLC App** aus App Store laden (kostenlos)
2. **Network** → **Stream öffnen** 
3. URL eingeben: `rtsp://192.168.1.169:8554/emily`
4. **Fertig!** 🎥

### Für Android:
1. **VLC App** oder **MX Player** installieren  
2. **Netzwerk-Stream** öffnen
3. URL eingeben: `rtsp://192.168.1.169:8554/emily`
4. **Fertig!** 🎥

### Für Mac/PC:
- **VLC**: Medien → Netzwerk-Stream öffnen
- **QuickTime**: Datei → Adresse öffnen  
- URL: `rtsp://192.168.1.169:8554/emily`

## 🌐 Andere WLANs (IT-Kurs)

```bash
sudo ./scripts/wifi-setup.sh
```

**URLs je nach Netzwerk:**
- **Zu Hause**: `rtsp://192.168.1.169:8554/emily`
- **Hotspot**: `rtsp://10.42.0.1:8554/emily`
- **Schulung**: `rtsp://[PI-IP]:8554/emily`

## ⚙️ Service-Kontrolle

```bash
# Status prüfen
sudo systemctl status emily-stream.service

# Neustarten (bei Problemen)
sudo systemctl restart emily-stream.service

# Logs anzeigen  
journalctl -u emily-stream.service -f
```

## 📺 YouTube Streaming

```bash
# 1. YouTube-Key eintragen
cp config/youtube-key.txt.template config/youtube-key.txt
nano config/youtube-key.txt  # Key einfügen

# 2. Von Mac/PC aus streamen
./scripts/youtube-stream.sh
```

## 🔧 Bei Problemen

**Stream geht nicht?**
```bash
sudo systemctl restart emily-stream.service
```

**Falsche IP-Adresse?**  
```bash
hostname -I  # Aktuelle IP anzeigen
```

**WLAN-Probleme?**
```bash
sudo ./scripts/wifi-setup.sh  # Netzwerk wechseln
```

---

## ✅ Warum RTSP?

- ✅ **Funktioniert überall**: iPhone, Android, Mac, PC
- ✅ **Echtes Live-Streaming**: < 1 Sekunde Verzögerung  
- ✅ **Super einfach**: Eine URL, keine komplizierten Setups
- ✅ **Professioneller Standard**: Verwendet von IP-Kameras weltweit

**So einfach kann Livestreaming sein! 🎥✨**
