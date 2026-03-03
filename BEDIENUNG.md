# Piepswatch - Bedienung

## Stream schauen (lokal, im Heimnetz)

Der RTSP-Stream läuft automatisch beim Booten.

**VLC** (iPhone, Android, Mac, PC):
```
rtsp://192.168.1.169:8554/emily
```

---

## Fernzugriff (wenn unterwegs)

Verbindung läuft über **Tailscale** (muss auf Handy/Laptop installiert sein).

### Zuhause (lokales Netz)
```bash
ssh piepswatch
```

### Unterwegs (via Tailscale)
```bash
ssh piepswatch-remote
```

SSH Config (`~/.ssh/config`):
```
Host piepswatch
  HostName 192.168.1.169
  User emily
  IdentityFile ~/.ssh/id_ed25519

Host piepswatch-remote
  HostName 100.x.x.x        # Tailscale-IP aus web.tailscale.com
  User emily
  IdentityFile ~/.ssh/id_ed25519
```

SSH-Key auf Pi einrichten (einmalig):
```bash
ssh-copy-id emily@100.x.x.x
```

### Stream-Status prüfen
```bash
sudo systemctl status emily-stream
```

### Stream manuell starten/stoppen
```bash
sudo systemctl start emily-stream
sudo systemctl stop emily-stream
```

---

## YouTube Live Stream (wenn verreist)

Starten:
```bash
ssh piepswatch-remote "sudo systemctl start piepswatch-youtube"
```

Stoppen:
```bash
ssh piepswatch-remote "sudo systemctl stop piepswatch-youtube"
```

Status:
```bash
ssh piepswatch-remote "sudo systemctl status piepswatch-youtube"
```

Der YouTube-Stream braucht den RTSP-Stream — der muss laufen.

### Stream-Key erneuern
```bash
ssh piepswatch
echo 'NEUER-KEY' > ~/piepswatch-birdcam/config/youtube-key.txt
```
Key holen: https://studio.youtube.com → Live übertragen → Stream-Einstellungen

---

## Automatischer Timer

Der RTSP-Stream startet/stoppt automatisch:
- **06:00** → Stream startet
- **21:00** → Stream stoppt

Timer anpassen (als root):
```bash
sudo crontab -e
```

---

## Stromsparmodus

Läuft automatisch beim Boot (piepswatch-power.service):
- CPU: powersave (600 MHz im Leerlauf)
- LEDs: aus
- HDMI: deaktiviert
- Bluetooth: deaktiviert
- Audio: deaktiviert

**Akku-Schätzung** (15000 mAh / 55.5 Wh):
- Stream aktiv: ~2 W → ca. 27 Stunden
- Mit Timer (15 h/Tag): ca. 2 Tage

---

## Bei Problemen

Stream hängt:
```bash
sudo systemctl restart emily-stream
```

IP-Adresse vergessen:
```bash
hostname -I
```

Logs anschauen:
```bash
journalctl -u emily-stream -f
journalctl -u piepswatch-youtube -f
```
