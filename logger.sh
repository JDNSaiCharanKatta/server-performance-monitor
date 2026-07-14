#!/usr/bin/env bash

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/server-report.log"

mkdir -p "${LOG_DIR}"
touch "${LOG_FILE}"


log_info()
{
    echo "[INFO] $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" >> "${LOG_FILE}"
}


log_success()
{
    echo "[SUCCESS] $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [SUCCESS] $1" >> "${LOG_FILE}"
}


log_error()
{
    echo "[ERROR] $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" >> "${LOG_FILE}"
}


log_section()
{
    echo
    echo "==============================================================="
    echo "$1"
    echo "==============================================================="
    echo "$(date '+%Y-%m-%d %H:%M:%S') ===== $1 =====" >> "${LOG_FILE}"
}
