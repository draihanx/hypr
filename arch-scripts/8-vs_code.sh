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
    __     __          ____            _                 
    \ \   / /___      / ___| ___    __| |  ___           
     \ \ / // __|    | |    / _ \  / _` | / _ \          
      \ V / \__ \ _  | |___| (_) || (_| ||  __/  _  _  _ 
       \_/  |___/(_)  \____|\___/  \__,_| \___| (_)(_)(_)
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/ve-code.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

aur_helper=$(command -v yay || command -v paru) # find the aur helper

vs_code=(
    visual-studio-code-bin
)

# installing vs code
for code in "${vs_code[@]}"; do
    install_from_aur "$code"
    if sudo "$aur_helper" -Qs "$code" &>> /dev/null; then
        echo "[ DONE ] - $code was installed successfully!\n" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $code!\n" 2>&1 | tee -a "$log" &>> /dev/null
    fi
done

# updating vs code themes
common_scripts="$present_dir/common"
"$common_scripts/vs_code_theme.sh"

# clear
