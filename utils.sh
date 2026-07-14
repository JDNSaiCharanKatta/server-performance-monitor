#!/usr/bin/env bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"
BOLD="\e[1m"
RESET="\e[0m"

print_banner(){

echo -e "${CYAN}"

echo "=============================================================="
echo "          LINUX SERVER PERFORMANCE MONITOR"
echo "=============================================================="

echo -e "${RESET}"

}

print_section(){

echo
echo -e "${BLUE}${BOLD}$1${RESET}"
echo "--------------------------------------------------------------"

}

print_footer(){

echo
echo -e "${GREEN}"
echo "=============================================================="
echo "            SERVER HEALTH CHECK COMPLETED"
echo "=============================================================="
echo -e "${RESET}"

}

health_status(){

value=$1
warning=$2
critical=$3

if [ "$value" -ge "$critical" ]
then
echo -e "${RED}CRITICAL${RESET}"

elif [ "$value" -ge "$warning" ]
then
echo -e "${YELLOW}WARNING${RESET}"

else
echo -e "${GREEN}OK${RESET}"

fi

}
