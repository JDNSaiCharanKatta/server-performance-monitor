#!/usr/bin/env bash

show_hostname(){

printf "%-25s : %s\n" "Hostname" "$(hostname)"

}

show_os(){

printf "%-25s : %s\n" "Operating System" "$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"

}

show_kernel(){

printf "%-25s : %s\n" "Kernel Version" "$(uname -r)"

}

show_architecture(){

printf "%-25s : %s\n" "Architecture" "$(uname -m)"

}

show_ip(){

printf "%-25s : %s\n" "IP Address" "$(hostname -I | awk '{print $1}')"

}

show_uptime(){

printf "%-25s : %s\n" "Uptime" "$(uptime -p)"

}

show_last_boot(){

printf "%-25s : %s\n" "Last Boot" "$(who -b | awk '{print $3,$4}')"

}

show_load_average(){

printf "%-25s : %s\n" "Load Average" "$(uptime | awk -F'load average:' '{print $2}')"

}
