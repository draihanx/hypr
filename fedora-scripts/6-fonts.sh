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
     _____              _                  
    |  ___|___   _ __  | |_  ___           
    | |_  / _ \ | '_ \ | __|/ __|          
    |  _|| (_) || | | || |_ \__ \  _  _  _ 
    |_|   \___/ |_| |_| \__||___/ (_)(_)(_)
                                      
EOF
}

clear && display_text
printf " \n \n"


###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/fonts.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi


# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

# installable fonts will be here
fonts=(
fontawesome-fonts-all
google-noto-sans-cjk-fonts
google-noto-color-emoji-fonts
google-noto-emoji-fonts
jetbrains-mono-fonts
)

# Installation of main components
printf "${action} - Installing necessary fonts.... \n"

for font in "${fonts[@]}"; do
  install_package "$font" || printf "${error} - Sorry, could not install $font\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
done

DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" && break
    printf "Download attempt $ATTEMPT failed. Retrying in 2 seconds...\n"
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd
fi

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd

# Update font cache and log the output
fc-cache -v

# clean up 
if [ -d "JetBrainsMono.tar.xz" ]; then
	rm -r JetBrainsMono.tar.xz
fi

clear
