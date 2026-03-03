#!/bin/bash
# Piepswatch Power Saving - läuft beim Boot

# CPU auf powersave (Zero 2W läuft mit 600MHz statt 1GHz im Leerlauf)
for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo powersave > "$gov" 2>/dev/null
done

# ACT LED aus (grüne Blink-LED)
echo none > /sys/class/leds/ACT/trigger 2>/dev/null
echo 0 > /sys/class/leds/ACT/brightness 2>/dev/null

# mmc0 LED aus
echo none > /sys/class/leds/mmc0/trigger 2>/dev/null
echo 0 > /sys/class/leds/mmc0/brightness 2>/dev/null

# Display aus (für den Fall dass mal was angeschlossen ist)
vcgencmd display_power 0 2>/dev/null

exit 0
