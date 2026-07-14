#!/usr/bin/env bash

###############################################################################
# Process Monitoring Module
###############################################################################

###############################################################################
# Total Processes
###############################################################################

total_processes() {

    echo
    echo "Total Processes"
    echo "--------------------------------------------------------------"

    printf "%-30s : %s\n" "Running Processes" "$(ps -e --no-headers | wc -l)"
}

###############################################################################
# Process States
###############################################################################

process_states() {

    echo
    echo "Process States"
    echo "--------------------------------------------------------------"

    running=$(ps -eo stat | awk '/^R/{count++} END{print count+0}')
    sleeping=$(ps -eo stat | awk '/^S/{count++} END{print count+0}')
    stopped=$(ps -eo stat | awk '/^T/{count++} END{print count+0}')
    zombie=$(ps -eo stat | awk '/^Z/{count++} END{print count+0}')

    printf "%-30s : %s\n" "Running" "$running"
    printf "%-30s : %s\n" "Sleeping" "$sleeping"
    printf "%-30s : %s\n" "Stopped" "$stopped"
    printf "%-30s : %s\n" "Zombie" "$zombie"
}

###############################################################################
# Top CPU Processes
###############################################################################

top_cpu_processes() {

    echo
    echo "Top 10 CPU Consuming Processes"
    echo "--------------------------------------------------------------"

    ps -eo pid,comm,%cpu,%mem,user --sort=-%cpu | head -11
}

###############################################################################
# Top Memory Processes
###############################################################################

top_memory_processes() {

    echo
    echo "Top 10 Memory Consuming Processes"
    echo "--------------------------------------------------------------"

    ps -eo pid,comm,%cpu,%mem,user --sort=-%mem | head -11
}

###############################################################################
# Zombie Process Details
###############################################################################

zombie_processes() {

    echo
    echo "Zombie Process Details"
    echo "--------------------------------------------------------------"

    zombies=$(ps -eo pid,ppid,user,stat,comm | awk '$4 ~ /^Z/')

    if [[ -n "$zombies" ]]; then
        echo "$zombies"
    else
        echo "No Zombie Processes Found"
    fi
}

###############################################################################
# High CPU Alert
###############################################################################

high_cpu_alert() {

    echo
    echo "Processes Using More Than 80% CPU"
    echo "--------------------------------------------------------------"

    result=$(ps -eo pid,user,%cpu,comm --sort=-%cpu | awk '$3>80')

    if [[ -n "$result" ]]; then
        echo "$result"
    else
        echo "No process is using more than 80% CPU."
    fi
}

###############################################################################
# High Memory Alert
###############################################################################

high_memory_alert() {

    echo
    echo "Processes Using More Than 50% Memory"
    echo "--------------------------------------------------------------"

    result=$(ps -eo pid,user,%mem,comm --sort=-%mem | awk '$3>50')

    if [[ -n "$result" ]]; then
        echo "$result"
    else
        echo "No process is using more than 50% Memory."
    fi
}

###############################################################################
# Recently Started Processes
###############################################################################

recent_processes() {

    echo
    echo "Recently Started Processes"
    echo "--------------------------------------------------------------"

    ps -eo lstart,pid,user,comm --sort=lstart | tail -10
}

###############################################################################
# Process Tree
###############################################################################

process_tree() {

    echo
    echo "Process Tree"
    echo "--------------------------------------------------------------"

    if command -v pstree >/dev/null 2>&1; then
        pstree -p
    else
        echo "pstree command is not installed."
    fi
}

###############################################################################
# Top Threads
###############################################################################

top_threads() {

    echo
    echo "Top Threads"
    echo "--------------------------------------------------------------"

    ps -eLo pid,tid,pcpu,pmem,comm --sort=-pcpu | head -15
}

###############################################################################
# Process Summary
###############################################################################

process_summary() {

    log_section "PROCESS INFORMATION"

    total_processes
    process_states
    top_cpu_processes
    top_memory_processes
    zombie_processes
    high_cpu_alert
    high_memory_alert
    recent_processes
    process_tree
    top_threads
}
