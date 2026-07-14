#!/usr/bin/env bash

###############################################################################
# Linux Server Performance Monitor
# Main Script
###############################################################################

set -Eeuo pipefail

# Script Directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Error Handler
trap 'echo "[ERROR] Script failed at line $LINENO"; exit 1' ERR

###############################################################################
# Verify Required Files
###############################################################################

required_files=(
    config.conf
    logger.sh
    utils.sh
    functions.sh
    cpu.sh
    memory.sh
    disk.sh
    filesystem.sh
    network.sh
    process.sh
    docker.sh
    security.sh
)

for file in "${required_files[@]}"; do
    if [[ ! -f "${BASE_DIR}/${file}" ]]; then
        echo "ERROR: Missing file -> ${file}"
        exit 1
    fi
done

###############################################################################
# Load Configuration
###############################################################################

source "${BASE_DIR}/config.conf"

###############################################################################
# Load Common Modules
###############################################################################

source "${BASE_DIR}/logger.sh"
source "${BASE_DIR}/utils.sh"
source "${BASE_DIR}/functions.sh"

###############################################################################
# Load Monitoring Modules
###############################################################################

source "${BASE_DIR}/cpu.sh"
source "${BASE_DIR}/memory.sh"
source "${BASE_DIR}/disk.sh"
source "${BASE_DIR}/filesystem.sh"
source "${BASE_DIR}/network.sh"
source "${BASE_DIR}/process.sh"
source "${BASE_DIR}/docker.sh"
source "${BASE_DIR}/security.sh"

###############################################################################
# Start Monitoring
###############################################################################

clear

print_banner

log_section "SERVER PERFORMANCE MONITOR"

log_info "Monitoring Started..."

echo

cpu_summary
memory_summary
disk_report
filesystem_report
network_report
process_summary
docker_report
security_report

echo

log_success "Monitoring Completed Successfully"

echo "==============================================================="
echo "        Server Performance Monitoring Completed"
echo "==============================================================="
