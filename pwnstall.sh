#!/bin/bash

# Function to prompt for update
function prompt_update() {
    read -p "Do you want to update (not upgrade) before beginning? (y/n): " update_choice
    if [ "$update_choice" == "y" ]; then
        sudo apt update
    fi
}

# Function to list and install plugin repositories
function install_repos() {
    repos=(
        "https://github.com/evilsocket/pwnagotchi-plugin-contrib/archive/master.zip"
        "https://github.com/PwnPeter/pwnagotchi-plugins/archive/master.zip"
        "https://github.com/Teraskull/pwnagotchi-community-plugins/archive/master.zip"
        "https://github.com/itsdarklikehell/pwnagotchi-plugins/archive/refs/heads/master.zip"
    )

    echo "Available repositories:"
    for i in "${!repos[@]}"; do
        echo "$((i+1)). ${repos[i]}"
    done

    while true; do
        read -p "Enter the number of the repository to install or 'a' for all repos (q to quit): " repo_choice
        if [ "$repo_choice" == "q" ]; then
            break
        elif [ "$repo_choice" == "a" ]; then
            install_all_repos
            break
        elif [[ "$repo_choice" =~ ^[0-9]+$ ]] && [ "$repo_choice" -ge 1 ] && [ "$repo_choice" -le "${#repos[@]}" ]; then
            install_repo "${repos[$((repo_choice-1))]}"
        else
            echo "Invalid choice, please try again."
        fi
    done
}

# Function to install all repositories
function install_all_repos() {
    for repo in "${repos[@]}"; do
        install_repo "$repo"
    done
}

# Function to install a single repository
function install_repo() {
    repo_url="$1"
    echo "Choose where you want to install your plugins:"
    echo "1. /usr/local/share/pwnagotchi/custom-plugins"
    echo "2. /usr/local/share/pwnagotchi/installed-plugins"
    echo "3. /usr/local/share/pwnagotchi/available-plugins"
    read -p "Enter the number of the location: " location_choice
    case $location_choice in
        1) location="/usr/local/share/pwnagotchi/custom-plugins" ;;
        2) location="/usr/local/share/pwnagotchi/installed-plugins" ;;
        3) location="/usr/local/share/pwnagotchi/available-plugins" ;;
        *) echo "Invalid choice, defaulting to /usr/local/share/pwnagotchi/custom-plugins"
           location="/usr/local/share/pwnagotchi/custom-plugins" ;;
    esac

    wget -qO- "$repo_url" | bsdtar -xf- -C "$location"
    echo "Repository installed to $location"
}

# Function to install selected packages
function install_packages() {
    packages=(
        msmtp msmtp-mta mailutils mpack hcxtools johntheripper wireguard surfshark wireshark openvpn wireguard-manager python
        inotify-tools inotify vagrant virtualbox wordninja tabulate MQTT NFTY Nextcloud gammu-smsd gammu gnokii-cli ircp-tray
        mmsd-tng obexftp obexpushd onioncat smsclient smstools aide-dynamic anacron apt-offline-gui apt-venv apticron atsar autopsy
        backup2l backupninja bluetooth bluez bluez-test-tools boot-info-script artikulate aircrack-ng airgraph-ng autossh
        autodns-dhcp bandwidthd bluemon brutespray bti bully capstats chaosreader chatty comitup cowpatty darkstat davmail dirb dnsmap
        droopy dsniff eapoltest easyssh ethtool firewalk fling ftpwatch hunt hydra hydra-gtk ifmetric ifplugd ifrename ifstat iftop
        inetutils-ftp macchanger mdk3 mdk4 mii-diag mininet modem-manager-gui mosquitto mosquitto-clients mozillavpn onionshare
        onionshare-cli packit pads purple-discord secvpn sipgrep sipcrack sipsak sipwitch talk traceroute websploit wpasupplicant
        bruteforce-wallet
    )

    echo "Available packages:"
    sorted_packages=($(echo "${packages[@]}" | tr ' ' '\n' | sort))
    for i in "${!sorted_packages[@]}"; do
        echo "$((i+1)). ${sorted_packages[i]}"
    done

    while true; do
        read -p "Enter the numbers of the packages to install (comma-separated) or 'a' for all packages (q to quit): " package_choice
        if [ "$package_choice" == "q" ]; then
            break
        elif [ "$package_choice" == "a" ]; then
            install_all_packages
            break
        else
            IFS=',' read -ra choices <<< "$package_choice"
            for choice in "${choices[@]}"; do
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#sorted_packages[@]}" ]; then
                    sudo apt install -y "${sorted_packages[$((choice-1))]}"
                else
                    echo "Invalid choice: $choice"
                fi
            done
        fi
    done
}

# Function to install all packages
function install_all_packages() {
    sudo apt install -y "${sorted_packages[@]}"
}

# Main script logic
prompt_update
install_repos
install_packages

echo "Thank you for using Pwnstall. Brought to you by BThomas22x of Cobra_Dev."
echo "If any packages or repositories were installed, the Pwnagotchi will need to be restarted."
read -p "Choose an option: (1) Shutdown, (2) Reboot, (3) Restart Pwnagotchi, (4) Restart in Auto mode, (5) Restart in Manual mode: " restart_choice

case $restart_choice in
    1) sudo shutdown now ;;
    2) sudo reboot ;;
    3) sudo systemctl restart pwnagotchi ;;
    4) sudo touch /root/.pwnagotchi-auto && sudo systemctl restart pwnagotchi ;;
    5) sudo touch /root/.pwnagotchi-manu && sudo systemctl restart pwnagotchi ;;
    *) echo "Invalid choice, exiting." ;;
esac
