#!/usr/bin/env bash
###############################################################################
# File        : health-check.sh
# Description : Quick Server Health Check
# Author      : Your Name
# Version     : 2.0
###############################################################################

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration
source "${BASE_DIR}/config.conf"
source "${BASE_DIR}/utils.sh"
source "${BASE_DIR}/logger.sh"

###############################################################################
# Banner
###############################################################################

print_banner

echo
echo "Quick Health Check"
echo "===================================================================="

###############################################################################
# CPU
###############################################################################

CPU=$(top -bn1 | awk -F',' '/Cpu\(s\)/{print int(100-$4)}')

if (( CPU >= CPU_CRITICAL )); then
    CPU_STATUS="${RED}CRITICAL${RESET}"
elif (( CPU >= CPU_WARNING )); then
    CPU_STATUS="${YELLOW}WARNING${RESET}"
else
    CPU_STATUS="${GREEN}OK${RESET}"
fi

###############################################################################
# Memory
###############################################################################

MEM=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

if (( MEM >= MEM_CRITICAL )); then
    MEM_STATUS="${RED}CRITICAL${RESET}"
elif (( MEM >= MEM_WARNING )); then
    MEM_STATUS="${YELLOW}WARNING${RESET}"
else
    MEM_STATUS="${GREEN}OK${RESET}"
fi

###############################################################################
# Root Disk
###############################################################################

DISK=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

if (( DISK >= DISK_CRITICAL )); then
    DISK_STATUS="${RED}CRITICAL${RESET}"
elif (( DISK >= DISK_WARNING )); then
    DISK_STATUS="${YELLOW}WARNING${RESET}"
else
    DISK_STATUS="${GREEN}OK${RESET}"
fi

###############################################################################
# Swap
###############################################################################

SWAP_TOTAL=$(free | awk '/Swap:/ {print $2}')
SWAP_USED=$(free | awk '/Swap:/ {print $3}')

if [[ "$SWAP_TOTAL" -eq 0 ]]; then
    SWAP="N/A"
else
    SWAP=$(awk "BEGIN {printf \"%.0f\", ($SWAP_USED/$SWAP_TOTAL)*100}")
fi

###############################################################################
# Load Average
###############################################################################

LOAD=$(uptime | awk -F'load average:' '{print $2}')

###############################################################################
# Uptime
###############################################################################

UPTIME=$(uptime -p)

###############################################################################
# Processes
###############################################################################

RUNNING=$(ps -e --no-headers | wc -l)
ZOMBIE=$(ps -eo stat | grep -c "^Z" || true)

###############################################################################
# Docker
###############################################################################

if command -v docker >/dev/null 2>&1; then
    DOCKER=$(systemctl is-active docker 2>/dev/null || echo "inactive")
else
    DOCKER="Not Installed"
fi

###############################################################################
# Kubernetes
###############################################################################

if command -v kubectl >/dev/null 2>&1; then
    if kubectl cluster-info >/dev/null 2>&1; then
        K8S="Connected"
    else
        K8S="Not Connected"
    fi
else
    K8S="Not Installed"
fi

###############################################################################
# Output
###############################################################################

printf "%-25s : %s%%\n" "CPU Usage" "$CPU"
printf "%-25s : %b\n" "CPU Status" "$CPU_STATUS"

echo

printf "%-25s : %s%%\n" "Memory Usage" "$MEM"
printf "%-25s : %b\n" "Memory Status" "$MEM_STATUS"

echo

printf "%-25s : %s%%\n" "Disk Usage" "$DISK"
printf "%-25s : %b\n" "Disk Status" "$DISK_STATUS"

echo

printf "%-25s : %s\n" "Swap Usage" "$SWAP"

echo

printf "%-25s : %s\n" "Load Average" "$LOAD"
printf "%-25s : %s\n" "System Uptime" "$UPTIME"

echo

printf "%-25s : %s\n" "Running Processes" "$RUNNING"
printf "%-25s : %s\n" "Zombie Processes" "$ZOMBIE"

echo

printf "%-25s : %s\n" "Docker" "$DOCKER"
printf "%-25s : %s\n" "Kubernetes" "$K8S"

echo
echo "===================================================================="

###############################################################################
# Overall Health
###############################################################################

if (( CPU >= CPU_CRITICAL || MEM >= MEM_CRITICAL || DISK >= DISK_CRITICAL )); then
    OVERALL="${RED}CRITICAL${RESET}"
elif (( CPU >= CPU_WARNING || MEM >= MEM_WARNING || DISK >= DISK_WARNING )); then
    OVERALL="${YELLOW}WARNING${RESET}"
else
    OVERALL="${GREEN}HEALTHY${RESET}"
fi

printf "%-25s : %b\n" "Overall Health" "$OVERALL"

echo "===================================================================="

log_info "Quick health check completed successfully."
