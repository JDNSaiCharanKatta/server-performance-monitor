#!/usr/bin/env bash

cpu_usage() {

    usage=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')

    status=$(health_status "$usage" "$CPU_WARNING" "$CPU_CRITICAL")

    printf "%-25s : %s %%\n" "CPU Usage" "$usage"
    printf "%-25s : %b\n" "Health Status" "$status"
}

cpu_model() {

    model=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)

    printf "%-25s : %s\n" "CPU Model" "$model"
}

cpu_cores() {

    cores=$(nproc)

    printf "%-25s : %s\n" "CPU Cores" "$cores"
}

cpu_frequency() {

    freq=$(lscpu | awk -F: '/CPU MHz/ {print $2}' | xargs)

    [ -z "$freq" ] && freq="N/A"

    printf "%-25s : %s MHz\n" "CPU Frequency" "$freq"
}

cpu_load() {

    load=$(uptime | awk -F'load average:' '{print $2}')

    printf "%-25s : %s\n" "Load Average" "$load"
}

###############################################################################
# CPU SUMMARY
###############################################################################

cpu_summary() {

    log_section "CPU INFORMATION"

    cpu_model
    cpu_cores
    cpu_frequency
    cpu_usage
    cpu_load

    echo
}
