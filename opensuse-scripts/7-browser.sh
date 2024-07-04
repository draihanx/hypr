#!/bin/bash


# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat << "EOF"
     ____                                                  
    | __ )  _ __  ___ __      __ ___   ___  _ __           
    |  _ \ | '__|/ _ \\ \ /\ / // __| / _ \| '__|          
    | |_) || |  | (_) |\ V  V / \__ \|  __/| |     _  _  _ 
    |____/ |_|   \___/  \_/\_/  |___/ \___||_|    (_)(_)(_)
                                                    
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/browser.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

# asking which browser wants to install
printf "Which browser would you like to install?\n1) ${orange}Brave-Browser.${end} \n2) ${cyan}Chromium.${end}"
read -p "Select: " browser
printf " \n"

if [[ "$browser" == "1" ]]; then
    printf "${action} - Installing ${orange}Brave-Browser${end}\n"
    sudo zypper install curl
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo 
    sleep 0.5
    sudo zypper in -y brave-browser
    sleep 1 && clear
elif [[ "$browser" == "2" ]]; then
    printf "${action} - Installing ${cyan}Chromium${end}\n"
    install_package chromium 2>&1 | tee -a "$log"
    sleep 1 && clear
else
    printf "${attention} - A browser installation is important to open some web-applications\n"
    exit 1
fi
