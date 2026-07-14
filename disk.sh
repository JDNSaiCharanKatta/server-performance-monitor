#!/usr/bin/env bash

###############################################################################
# File        : disk.sh
# Description : Disk Monitoring Module
# Version     : 2.0
###############################################################################

set -Eeuo pipefail

###############################################################################
# Print Disk Usage
###############################################################################

disk_usage() {

    echo
    printf "%-25s %-10s %-10s %-10s %-8s %-12s\n" \
    "Filesystem" "Size" "Used" "Free" "Use%" "Status"

    echo "-------------------------------------------------------------------------------"

    df -hP | awk 'NR>1' | while read -r fs size used avail use mount
    do

        percent=$(echo "$use" | tr -d '%')

        if [[ "$percent" -ge "$DISK_CRITICAL" ]]; then
            status="${RED}CRITICAL${RESET}"

        elif [[ "$percent" -ge "$DISK_WARNING" ]]; then
            status="${YELLOW}WARNING${RESET}"

        else
            status="${GREEN}OK${RESET}"
        fi

        printf "%-25s %-10s %-10s %-10s %-8s %-12b\n" \
        "$mount" "$size" "$used" "$avail" "$use" "$status"

    done

}

###############################################################################
# Disk Summary
###############################################################################

disk_summary() {

    echo
    echo "Overall Disk Usage"
    echo "------------------------------------------------"

    df -h --total | awk '/total/{

        printf "Total Size     : %s\n",$2
        printf "Used Space     : %s\n",$3
        printf "Available      : %s\n",$4
        printf "Usage          : %s\n",$5

    }'

}

###############################################################################
# Largest Directories
###############################################################################

largest_directories() {

    echo
    echo "Top 10 Largest Directories (/)"
    echo "------------------------------------------------"

    sudo du -xh / \
        --max-depth=1 \
        2>/dev/null | sort -hr | head -10

}

###############################################################################
# Largest Files
###############################################################################

largest_files() {

    echo
    echo "Top 10 Largest Files"
    echo "------------------------------------------------"

    sudo find / \
        -type f \
        -exec du -h {} + \
        2>/dev/null | sort -hr | head -10

}

###############################################################################
# Inode Usage
###############################################################################

inode_usage() {

    echo
    echo "Inode Usage"
    echo "------------------------------------------------"

    df -iP | awk 'NR==1 || NR>1{

        printf "%-25s %-10s %-10s %-10s %-8s\n",

        $6,$2,$3,$4,$5

    }'

}

###############################################################################
# Mounted File Systems
###############################################################################

mounted_filesystems() {

    echo
    echo "Mounted File Systems"
    echo "------------------------------------------------"

    mount | column -t

}

###############################################################################
# Read Only File Systems
###############################################################################

readonly_filesystems() {

    echo
    echo "Read Only Mounts"
    echo "------------------------------------------------"

    mount | grep "(ro"

}

###############################################################################
# Disk I/O Statistics
###############################################################################

disk_io() {

    echo
    echo "Disk I/O"
    echo "------------------------------------------------"

    if command -v iostat >/dev/null 2>&1
    then

        iostat -dx 1 1

    else

        echo "Install sysstat package"

    fi

}

###############################################################################
# Open Files
###############################################################################

open_files() {

    echo
    echo "Open Files"
    echo "------------------------------------------------"

    if command -v lsof >/dev/null 2>&1
    then

        echo "Total Open Files : $(lsof | wc -l)"

    else

        echo "lsof not installed"

    fi

}

###############################################################################
# Disk Health
###############################################################################

disk_health() {

    echo
    echo "Disk Health"
    echo "------------------------------------------------"

    lsblk

}

###############################################################################
# Complete Summary
###############################################################################

disk_report() {

    print_section "DISK INFORMATION"

    disk_summary

    echo

    disk_usage

    echo

    inode_usage

    echo

    open_files

    echo

    disk_health

}

###############################################################################
# End
###############################################################################
