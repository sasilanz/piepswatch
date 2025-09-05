#!/bin/bash
# Piepswatch - USB Ethernet Setup for IT Course
# Enables USB-Ethernet connection to Mac/PC for emergency access

echo "🔌 USB Ethernet Setup for Piepswatch"
echo "===================================="

# Check if USB Ethernet module is loaded
if ! lsmod | grep -q "g_ether"; then
    echo "⚙️ Enabling USB Ethernet..."
    
    # Add USB Ethernet to modules
    if ! grep -q "dwc2" /boot/config.txt; then
        echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
    fi
    
    if ! grep -q "dwc2" /etc/modules; then
        echo "dwc2" | sudo tee -a /etc/modules
    fi
    
    if ! grep -q "g_ether" /etc/modules; then
        echo "g_ether" | sudo tee -a /etc/modules
    fi
    
    echo "⚠️ Reboot required to activate USB Ethernet"
    echo "After reboot, connect USB cable to Mac and Pi should get IP 169.254.x.x"
else
    echo "✅ USB Ethernet is already enabled"
fi

# Create a static IP configuration for USB interface
cat > /tmp/usb_ethernet_config << 'EOL'
# USB Ethernet Configuration
# Add this to NetworkManager if needed

[connection]
id=usb-ethernet
uuid=12345678-1234-1234-1234-123456789012
type=ethernet
interface-name=usb0

[ipv4]
method=link-local
EOL

echo ""
echo "📋 USB Ethernet Configuration created in /tmp/usb_ethernet_config"
echo ""
echo "🔌 Usage Instructions:"
echo "1. Reboot the Pi after running this script"
echo "2. Connect USB cable between Pi and Mac"
echo "3. Pi should appear as network interface on Mac"
echo "4. Use link-local addressing (169.254.x.x)"
echo "5. Access Pi via SSH or direct connection"
echo ""
echo "💡 Tip: On Mac, the Pi usually gets an IP starting with 169.254."
echo "    Use 'arp -a' on Mac to find the Pi's IP address"
