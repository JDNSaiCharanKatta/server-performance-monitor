#!/usr/bin/env bash
###############################################################################
# File        : security.sh
# Description : Linux Security Monitoring Module
# Version     : 2.0
###############################################################################

set -Eeuo pipefail

###############################################################################
# Check Root User
###############################################################################

root_user() {

    echo
    echo "Current User"
    echo "--------------------------------------------------------------"

    if [[ "$EUID" -eq 0 ]]; then
        echo -e "${RED}Running as ROOT${RESET}"
    else
        echo -e "${GREEN}Running as User : $(whoami)${RESET}"
    fi

}

###############################################################################
# Failed Login Attempts
###############################################################################

failed_logins() {

    echo
    echo "Failed Login Attempts"
    echo "--------------------------------------------------------------"

    if [[ -f /var/log/auth.log ]]; then

        if grep -q "Failed password" /var/log/auth.log; then
            grep "Failed password" /var/log/auth.log | tail -10
        else
            echo "No failed login attempts found."
        fi

    elif [[ -f /var/log/secure ]]; then

        if grep -q "Failed password" /var/log/secure; then
            grep "Failed password" /var/log/secure | tail -10
        else
            echo "No failed login attempts found."
        fi

    else

        echo "Authentication log not found."

    fi

    return 0
}

###############################################################################
# Successful Logins
###############################################################################

successful_logins() {

    echo
    echo "Recent Successful Logins"
    echo "--------------------------------------------------------------"

    last -a | head -10

}

###############################################################################
# Logged-in Users
###############################################################################

logged_users() {

    echo
    echo "Currently Logged In Users"
    echo "--------------------------------------------------------------"

    who

}

###############################################################################
# SSH Service
###############################################################################

ssh_status() {

    echo
    echo "SSH Service"
    echo "--------------------------------------------------------------"

    if systemctl is-active --quiet ssh; then
        echo -e "${GREEN}SSH Service : Running${RESET}"
    elif systemctl is-active --quiet sshd; then
        echo -e "${GREEN}SSHD Service : Running${RESET}"
    else
        echo -e "${RED}SSH Service : Stopped${RESET}"
    fi

}

###############################################################################
# Firewall
###############################################################################

firewall_status() {

    echo
    echo "Firewall"
    echo "--------------------------------------------------------------"

    if command -v ufw >/dev/null 2>&1; then

        sudo ufw status

    elif command -v firewall-cmd >/dev/null 2>&1; then

        sudo firewall-cmd --state

    else

        echo "Firewall utility not installed."

    fi

}

###############################################################################
# SELinux
###############################################################################

selinux_status() {

    echo
    echo "SELinux"
    echo "--------------------------------------------------------------"

    if command -v getenforce >/dev/null 2>&1; then

        getenforce

    else

        echo "SELinux Not Available"

    fi

}

###############################################################################
# AppArmor
###############################################################################

apparmor_status() {

    echo
    echo "AppArmor"
    echo "--------------------------------------------------------------"

    if command -v aa-status >/dev/null 2>&1; then
        aa-status 2>&1 || true
    else
        echo "AppArmor Not Installed"
    fi
}
###############################################################################
# Sudo Users
###############################################################################

sudo_users() {

    echo
    echo "Users with sudo privileges"
    echo "--------------------------------------------------------------"

    getent group sudo 2>/dev/null || true
    getent group wheel 2>/dev/null || true

}

###############################################################################
# Password Expiry
###############################################################################

password_expiry() {

    echo
    echo "Password Expiry"
    echo "--------------------------------------------------------------"

    chage -l "$(whoami)" 2>/dev/null || true

}

###############################################################################
# World Writable Files
###############################################################################

world_writable() {

    echo
    echo "Top World Writable Files"
    echo "--------------------------------------------------------------"

    find / -xdev -type f -perm -0002 2>/dev/null | head -20

}

###############################################################################
# SUID Files
###############################################################################

suid_files() {

    echo
    echo "Top SUID Files"
    echo "--------------------------------------------------------------"

    find / -xdev -perm -4000 2>/dev/null | head -20

}

###############################################################################
# Open Ports
###############################################################################

open_ports() {

    echo
    echo "Listening Ports"
    echo "--------------------------------------------------------------"

    if command -v ss >/dev/null 2>&1
    then
        ss -tulnp
    else
        netstat -tulnp
    fi

}

###############################################################################
# Running Services
###############################################################################

running_services() {

    echo
    echo "Active Services"
    echo "--------------------------------------------------------------"

    systemctl list-units --type=service --state=running --no-pager

}

###############################################################################
# Security Updates
###############################################################################

security_updates() {

    echo
    echo "Security Updates"
    echo "--------------------------------------------------------------"

    if command -v unattended-upgrade >/dev/null 2>&1; then

        echo "Automatic Security Updates Configured"

    else

        echo "Automatic Security Updates Not Configured"

    fi

}

###############################################################################
# Security Report
###############################################################################

security_report() {

    print_section "SECURITY INFORMATION"

    root_user

    ssh_status

    firewall_status

    selinux_status

    apparmor_status

    logged_users

    successful_logins

    failed_logins

    sudo_users

    password_expiry

    open_ports

    security_updates

}

###############################################################################
# End
###############################################################################
