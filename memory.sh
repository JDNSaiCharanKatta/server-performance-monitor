#!/usr/bin/env bash
###############################################################################
# File        : memory.sh
# Description : Memory & Swap Monitoring Module
# Version     : 2.0
###############################################################################

set -Eeuo pipefail

###############################################################################
# Memory Usage
###############################################################################

memory_usage() {

    local total used free available cached buffers percent status

    total=$(free -m | awk '/^Mem:/ {print $2}')
    used=$(free -m | awk '/^Mem:/ {print $3}')
    free=$(free -m | awk '/^Mem:/ {print $4}')
    available=$(free -m | awk '/^Mem:/ {print $7}')

    cached=$(free -m | awk '/^Mem:/ {print $6}')
    buffers=$(free -m | awk '/^Mem:/ {print $6}')

    percent=$(awk "BEGIN {printf \"%.0f\", (${used}/${total})*100}")

    status=$(health_status "$percent" "$MEM_WARNING" "$MEM_CRITICAL")

    printf "%-30s : %s MB\n" "Total Memory" "$total"
    printf "%-30s : %s MB\n" "Used Memory" "$used"
    printf "%-30s : %s MB\n" "Free Memory" "$free"
    printf "%-30s : %s MB\n" "Available Memory" "$available"
    printf "%-30s : %s MB\n" "Cached Memory" "$cached"
    printf "%-30s : %s MB\n" "Buffers" "$buffers"
    printf "%-30s : %s %%\n" "Memory Usage" "$percent"
    printf "%-30s : %b\n" "Health Status" "$status"

    echo
    memory_bar "$percent"

}

###############################################################################
# Swap Usage
###############################################################################

swap_usage() {

    local total used free percent

    total=$(free -m | awk '/^Swap:/ {print $2}')
    used=$(free -m | awk '/^Swap:/ {print $3}')
    free=$(free -m | awk '/^Swap:/ {print $4}')

    if [[ "$total" -eq 0 ]]; then
        echo "Swap              : Not Configured"
        return
    fi

    percent=$(awk "BEGIN {printf \"%.0f\", (${used}/${total})*100}")

    printf "%-30s : %s MB\n" "Total Swap" "$total"
    printf "%-30s : %s MB\n" "Used Swap" "$used"
    printf "%-30s : %s MB\n" "Free Swap" "$free"
    printf "%-30s : %s %%\n" "Swap Usage" "$percent"

}

###############################################################################
# Memory Progress Bar
###############################################################################

memory_bar() {

    local percent=$1

    local bars=$((percent/2))
    local spaces=$((50-bars))

    printf "Usage Bar                     : "

    echo -ne "${GREEN}"

    for ((i=0;i<bars;i++))
    do
        echo -n "█"
    done

    echo -ne "${RESET}"

    for ((i=0;i<spaces;i++))
    do
        echo -n "░"
    done

    echo " ${percent}%"

}

###############################################################################
# Top Memory Processes
###############################################################################

top_memory_processes() {

    echo
    echo "Top 5 Memory Consuming Processes"
    echo "--------------------------------------------------------------"

    printf "%-10s %-25s %-10s %-10s\n" "PID" "PROCESS" "MEM%" "USER"

    ps -eo pid,comm,%mem,user --sort=-%mem | head -6

}

###############################################################################
# Memory Summary
###############################################################################

memory_summary() {

    print_section "MEMORY INFORMATION"

    memory_usage

    echo

    swap_usage

    echo

    top_memory_processes

}

###############################################################################
# End of File
###############################################################################
