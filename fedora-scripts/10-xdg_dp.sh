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
     ____              _     _                  ____               _          _           
    |  _ \   ___  ___ | | __| |_  ___   _ __   |  _ \  ___   _ __ | |_  __ _ | |          
    | | | | / _ \/ __|| |/ /| __|/ _ \ | '_ \  | |_) |/ _ \ | '__|| __|/ _` || |          
    | |_| ||  __/\__ \|   < | |_| (_) || |_) | |  __/| (_) || |   | |_| (_| || |  _  _  _ 
    |____/  \___||___/|_|\_\ \__|\___/ | .__/  |_|    \___/ |_|    \__|\__,_||_| (_)(_)(_)
                                       |_|                                                   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/desktop-portal.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

xdg=(
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
)


# XDG-DESKTOP-PORTAL-HYPRLAND
for xdgs in "${xdg[@]}"; do
  install_package "$xdgs" "$log"
done

printf "\n"

printf "${note} - Checking for other XDG-Desktop-Portal-Implementations....\n"
sleep 1
printf "\n"
printf "${note} - XDG-desktop-portal-KDE & GNOME (if installed) should be manually disabled or removed!\n"

while true; do
    printf "${attention} - Would you like to remove other XDG-Desktop-Portal-Implementations? ${cyan}[ y/n ]${end}\n"
    read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" XDPH1
    sleep 1

    case $XDPH1 in
        [Yy])
            # Clean out other portals
            printf "${note} - Clearing any other xdg-desktop-portal implementations...\n"
            # Check if packages are installed and uninstall if present
  			if sudo dnf list installed xdg-desktop-portal-wlr &>> /dev/null; then
    		printf "${action} - Removing xdg-desktop-portal-wlr...\n"
    		sudo dnf remove -y xdg-desktop-portal-wlr 2>&1 | tee -a "$log" &>> /dev/null
  			fi

  			if sudo dnf list installed xdg-desktop-portal-lxqt &>> /dev/null; then
    		printf "${action} - Removing xdg-desktop-portal-lxqt...\n"
    		sudo dnf remove -y xdg-desktop-portal-lxqt 2>&1 | tee -a "$log" &>> /dev/null
  			fi

            break
            ;;
        [Nn])
            printf "${attention} - no other XDG-implementations will be removed.\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &>> /dev/null
            break
            ;;
        *)
            printf "${error} - Invalid input. Please enter 'y' for yes or 'n' for no.\n"
            ;;
    esac
done
clear
