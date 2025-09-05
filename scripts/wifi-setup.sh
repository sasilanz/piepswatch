#!/bin/bash
# Piepswatch - Flexible WiFi Setup for IT Course
# Allows easy switching between different WiFi networks

set -e

SCRIPT_DIR="$(dirname "$0")"
CONFIG_DIR="$SCRIPT_DIR/../config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌐 Piepswatch WiFi Setup Tool${NC}"
echo "================================"

# Function to show current WiFi status
show_wifi_status() {
    echo -e "${YELLOW}Current WiFi Status:${NC}"
    iwconfig wlan0 2>/dev/null | grep -E "(ESSID|Quality|Signal)" || echo "No WiFi connected"
    echo ""
    echo -e "${YELLOW}IP Address:${NC}"
    hostname -I | awk '{print $1}' || echo "No IP assigned"
    echo ""
}

# Function to scan for available networks
scan_networks() {
    echo -e "${YELLOW}Scanning for available networks...${NC}"
    nmcli device wifi list
    echo ""
}

# Function to add a new WiFi network
add_network() {
    read -p "WiFi Network Name (SSID): " ssid
    read -s -p "WiFi Password: " password
    echo ""
    read -p "Connection Name (or press Enter for '$ssid'): " conn_name
    
    if [ -z "$conn_name" ]; then
        conn_name="$ssid"
    fi
    
    echo -e "${YELLOW}Adding network '$ssid' as '$conn_name'...${NC}"
    
    if nmcli connection add type wifi con-name "$conn_name" ssid "$ssid" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$password"; then
        echo -e "${GREEN}✅ Network '$conn_name' added successfully!${NC}"
        
        # Set priority (home network gets highest priority)
        if [[ "$ssid" == *"Welan"* ]] || [[ "$conn_name" == *"home"* ]]; then
            nmcli connection modify "$conn_name" connection.autoconnect-priority 100
            echo -e "${GREEN}🏠 Set as high priority (home network)${NC}"
        else
            nmcli connection modify "$conn_name" connection.autoconnect-priority 50
            echo -e "${BLUE}📚 Set as medium priority (course network)${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to add network${NC}"
        return 1
    fi
}

# Function to connect to a specific network
connect_network() {
    echo -e "${YELLOW}Available connections:${NC}"
    nmcli connection show | grep wifi
    echo ""
    
    read -p "Connection name to connect to: " conn_name
    
    echo -e "${YELLOW}Connecting to '$conn_name'...${NC}"
    if nmcli connection up "$conn_name"; then
        echo -e "${GREEN}✅ Connected to '$conn_name'!${NC}"
        sleep 2
        show_wifi_status
    else
        echo -e "${RED}❌ Failed to connect to '$conn_name'${NC}"
    fi
}

# Function to create a WiFi hotspot
create_hotspot() {
    echo -e "${YELLOW}Creating WiFi Hotspot...${NC}"
    
    # Stop current WiFi connection
    nmcli device disconnect wlan0 2>/dev/null || true
    
    # Create hotspot
    nmcli device wifi hotspot ssid "Piepswatch-Demo" password "piepswatch123" con-name "piepswatch-hotspot"
    
    echo -e "${GREEN}✅ Hotspot created!${NC}"
    echo -e "${BLUE}Network: Piepswatch-Demo${NC}"
    echo -e "${BLUE}Password: piepswatch123${NC}"
    echo -e "${BLUE}Pi IP will be: 10.42.0.1${NC}"
    echo ""
    echo -e "${YELLOW}Camera stream will be available at:${NC}"
    echo -e "${BLUE}tcp://10.42.0.1:8888${NC}"
}

# Function to stop hotspot and reconnect to WiFi
stop_hotspot() {
    echo -e "${YELLOW}Stopping hotspot and reconnecting to WiFi...${NC}"
    nmcli connection down "piepswatch-hotspot" 2>/dev/null || true
    nmcli device disconnect wlan0
    sleep 2
    nmcli device connect wlan0
    echo -e "${GREEN}✅ Reconnected to WiFi${NC}"
}

# Main menu
while true; do
    echo ""
    echo -e "${BLUE}Choose an option:${NC}"
    echo "1) Show current WiFi status"
    echo "2) Scan for networks"
    echo "3) Add new WiFi network"
    echo "4) Connect to specific network"
    echo "5) Create WiFi hotspot (for demos)"
    echo "6) Stop hotspot and reconnect to WiFi"
    echo "0) Exit"
    echo ""
    
    read -p "Enter choice [0-6]: " choice
    
    case $choice in
        1) show_wifi_status ;;
        2) scan_networks ;;
        3) add_network ;;
        4) connect_network ;;
        5) create_hotspot ;;
        6) stop_hotspot ;;
        0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice. Please try again.${NC}" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
