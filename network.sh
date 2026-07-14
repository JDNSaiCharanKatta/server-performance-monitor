#!/usr/bin/env bash
###############################################################################
# File        : network.sh
# Description : Network Monitoring Module
# Version     : 2.0
###############################################################################

set -Eeuo pipefail

###############################################################################
# Network Interfaces
###############################################################################

network_interfaces() {

    echo
    echo "Network Interfaces"
    echo "--------------------------------------------------------------"

    ip -br addr show

}

###############################################################################
# IP Addresses
###############################################################################

ip_information() {

    echo
    echo "IP Address Information"
    echo "--------------------------------------------------------------"

    echo "Hostname        : $(hostname)"
    echo "Private IP      : $(hostname -I | awk '{print $1}')"

    if command -v curl >/dev/null 2>&1; then
        public_ip=$(curl -4 -s --max-time 5 https://ifconfig.me 2>/dev/null || echo "Unavailable")
        echo "Public IP       : $public_ip"
    else
        echo "Public IP       : curl not installed"
    fi

}

###############################################################################
# Default Gateway
###############################################################################

default_gateway() {

    echo
    echo "Default Gateway"
    echo "--------------------------------------------------------------"

    ip route | grep default || echo "No default gateway configured"

}

###############################################################################
# DNS Servers
###############################################################################

dns_information() {

    echo
    echo "DNS Servers"
    echo "--------------------------------------------------------------"

    grep "^nameserver" /etc/resolv.conf || true

}

###############################################################################
# Listening Ports
###############################################################################

listening_ports() {

    echo
    echo "Listening TCP/UDP Ports"
    echo "--------------------------------------------------------------"

    if command -v ss >/dev/null 2>&1; then
        ss -tuln
    else
        netstat -tuln
    fi

}

###############################################################################
# Established Connections
###############################################################################

established_connections() {

    echo
    echo "Established Connections"
    echo "--------------------------------------------------------------"

    if command -v ss >/dev/null 2>&1; then
        echo "Total Established Connections : $(ss -tun state established | tail -n +2 | wc -l)"
    else
        echo "Total Established Connections : $(netstat -an | grep ESTABLISHED | wc -l)"
    fi

}

###############################################################################
# Top Remote IP Connections
###############################################################################

top_connections() {

    echo
    echo "Top Remote Connections"
    echo "--------------------------------------------------------------"

    if command -v ss >/dev/null 2>&1; then
        ss -tun state established \
        | awk 'NR>1 {split($5,a,":"); print a[1]}' \
        | sort \
        | uniq -c \
        | sort -rn \
        | head
    fi

}

###############################################################################
# Network Statistics
###############################################################################

network_statistics() {

    echo
    echo "Interface Statistics"
    echo "--------------------------------------------------------------"

    ip -s link

}

###############################################################################
# Interface Traffic
###############################################################################

interface_traffic() {

    echo
    echo "RX/TX Statistics"
    echo "--------------------------------------------------------------"

    awk '
    BEGIN{
        printf "%-15s %-15s %-15s\n","Interface","RX(Bytes)","TX(Bytes)"
    }

    /:/{
        gsub(":","",$1)
        iface=$1
    }

    /RX:/{getline; rx=$1}

    /TX:/{getline; tx=$1; printf "%-15s %-15s %-15s\n",iface,rx,tx}

    ' /proc/net/dev

}

###############################################################################
# Packet Errors
###############################################################################

packet_errors() {

    echo
    echo "Packet Errors"
    echo "--------------------------------------------------------------"

    ip -s link | grep -E "^[0-9]|RX:|TX:|errors"

}

###############################################################################
# Internet Connectivity
###############################################################################

internet_connectivity() {

    echo
    echo "Internet Connectivity"
    echo "--------------------------------------------------------------"

    if ping -c2 -W2 8.8.8.8 >/dev/null 2>&1
    then
        echo -e "${GREEN}Internet : Connected${RESET}"
    else
        echo -e "${RED}Internet : Not Reachable${RESET}"
    fi

}

###############################################################################
# Routing Table
###############################################################################

routing_table() {

    echo
    echo "Routing Table"
    echo "--------------------------------------------------------------"

    ip route

}

###############################################################################
# Firewall Status
###############################################################################

firewall_status() {

    echo
    echo "Firewall Status"
    echo "--------------------------------------------------------------"

    if command -v ufw >/dev/null 2>&1
    then
        sudo ufw status

    elif command -v firewall-cmd >/dev/null 2>&1
    then
        sudo firewall-cmd --state

    else
        echo "Firewall utility not found"
    fi

}

###############################################################################
# Network Report
###############################################################################

network_report() {

    print_section "NETWORK INFORMATION"

    network_interfaces

    ip_information

    default_gateway

    dns_information

    internet_connectivity

    established_connections

    top_connections

    interface_traffic

    listening_ports

}

###############################################################################
# End
###############################################################################
