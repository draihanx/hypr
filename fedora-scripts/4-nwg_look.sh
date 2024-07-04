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


###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
mkdir -p "$log_dir"
log="$log_dir"/nwg-look.log
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

# packages to install nwg-look
packages=(
golang
gtk3
gtk3-devel
cairo-devel
glib-devel
)

# Installing NWG-Look Dependencies
for pkgs in "${packages[@]}"; do
  install_package "$pkgs" "$log"
done

printf "${action} Installing nwg-look\n"
# Check if nwg-look directory exists

    if [ -f '/usr/bin/nwg-look' ]; then
        printf "${done} - nwg-look is already installed..\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    else
        # Clone nwg-look repository if directory doesn't exist
        if git clone https://github.com/nwg-piotr/nwg-look.git "$present_dir/.cache/nwg-look" 2>&1 | tee -a "$log"; then
            cd "$present_dir/.cache/nwg-look"

            # Build nwg-look
            make build
            if sudo make install 2>&1 | tee -a "$log"; then
            printf "${done} nwg-look installed successfully.\n"
            else
            printf "${error} Installation failed for nwg-look\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            fi
        else
            echo -e "${error} - nwg-look was failed to download." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            # exit 1
        fi
    fi

clear
