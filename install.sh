#!/usr/bin/env bash

###############################################################################
# Linux Server Performance Monitor
# Installation Script
# Version : 2.0
###############################################################################

set -Eeuo pipefail

###############################################################################
# Colors
###############################################################################

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

###############################################################################
# Banner
###############################################################################

clear

echo -e "${CYAN}"
echo "=============================================================="
echo "      Linux Server Performance Monitor Installer"
echo "=============================================================="
echo -e "${RESET}"

###############################################################################
# Root Check
###############################################################################

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Please run this installer as root.${RESET}"
    echo "Example:"
    echo "sudo ./install.sh"
    exit 1
fi

###############################################################################
# Detect Operating System
###############################################################################

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
else
    echo "Unsupported Linux Distribution."
    exit 1
fi

echo
echo "Detected OS : $OS"

###############################################################################
# Install Packages
###############################################################################

install_packages() {

    case "$OS" in

        ubuntu|debian)

            apt update

            apt install -y \
            curl \
            wget \
            git \
            net-tools \
            iproute2 \
            dnsutils \
            procps \
            sysstat \
            lsof \
            psmisc \
            bc \
            jq

        ;;

        centos|rocky|almalinux|rhel)

            yum install -y \
            curl \
            wget \
            git \
            net-tools \
            iproute \
            bind-utils \
            procps-ng \
            sysstat \
            lsof \
            psmisc \
            bc \
            jq

        ;;

        amzn)

            yum install -y \
            curl \
            wget \
            git \
            net-tools \
            iproute \
            bind-utils \
            procps-ng \
            sysstat \
            lsof \
            psmisc \
            bc \
            jq

        ;;

        *)

            echo "Unsupported Distribution"
            exit 1

        ;;
    esac

}

###############################################################################
# Install
###############################################################################

echo
echo "Installing Required Packages..."
echo

install_packages

###############################################################################
# Create Directories
###############################################################################

echo
echo "Creating Directories..."

mkdir -p logs
mkdir -p reports

touch logs/server-report.log

###############################################################################
# Permissions
###############################################################################

echo
echo "Setting Permissions..."

find . -maxdepth 1 -name "*.sh" -exec chmod +x {} \;

###############################################################################
# Dependency Check
###############################################################################

echo
echo "Checking Installed Commands..."

commands=(
bash
awk
sed
grep
top
free
df
ps
ip
ss
curl
find
lsof
iostat
)

for cmd in "${commands[@]}"
do

    if command -v "$cmd" >/dev/null 2>&1
    then
        printf "%-20s : ${GREEN}OK${RESET}\n" "$cmd"
    else
        printf "%-20s : ${RED}Missing${RESET}\n" "$cmd"
    fi

done

###############################################################################
# Docker
###############################################################################

echo
echo "Docker"

if command -v docker >/dev/null 2>&1
then
    echo -e "${GREEN}Docker Installed${RESET}"
else
    echo -e "${YELLOW}Docker Not Installed (Optional)${RESET}"
fi

###############################################################################
# Kubernetes
###############################################################################

echo
echo "Kubectl"

if command -v kubectl >/dev/null 2>&1
then
    echo -e "${GREEN}Kubectl Installed${RESET}"
else
    echo -e "${YELLOW}Kubectl Not Installed (Optional)${RESET}"
fi

###############################################################################
# Summary
###############################################################################

echo
echo -e "${GREEN}"
echo "=============================================================="
echo "Installation Completed Successfully"
echo "=============================================================="
echo -e "${RESET}"

echo
echo "Directories Created"

echo "logs/"
echo "reports/"

echo
echo "Main Script"

echo "./server-stats.sh"

echo
echo "Quick Health Check"

echo "./health-check.sh"

echo
echo "Run Commands"

echo "--------------------------------"

echo "./server-stats.sh"

echo

echo "./health-check.sh"

echo

echo "Happy Monitoring!"
