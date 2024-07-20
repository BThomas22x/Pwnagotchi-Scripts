
#!/bin/bash

# Function to list all packages
list_packages() {
  echo "Packages available for installation:"
  for package in "${packages[@]}"; do
    echo "- $package"
  done
}

# Function to list all plugin repos
list_repos() {
  echo "Plugin repos available for installation:"
  for repo in "${repos[@]}"; do
    echo "- $repo"
  done
}

# Function to update package list
update_package_list() {
  echo "Do you want to update the package list? (sudo apt UPDATE) (y/n)"
  read update_choice
  if [[ $update_choice == "y" || $update_choice == "Y" ]]; then
    sudo apt update
  fi
}

# Function to install the MQTT package
install_mqtt() {
  sudo wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
  sudo apt-key add mosquitto-repo.gpg.key
  cd /etc/apt/sources.list.d
  sudo wget http://repo.mosquitto.org/debian/mosquitto-jessie.list
  sudo wget http://repo.mosquitto.org/debian/mosquitto-stretch.list
  sudo wget http://repo.mosquitto.org/debian/mosquitto-buster.list
  sudo apt update
  sudo apt-get install -y mosquitto
}

# Function to install packages
install_packages() {
  while true; do
    echo "Enter the names of the packages you want to install (separated by spaces, or type 'all' to install all packages):"
    read -a selected_packages
    if [[ "${selected_packages[@]}" == "all" ]]; then
      for package in "${packages[@]}"; do
        if [[ "$package" == "MQTT" ]]; then
          install_mqtt
        else
          sudo apt install -y $package
        fi
      done
      break
    else
for package in "${selected_packages[@]}"; do
        if [[ "$package" == "MQTT" ]]; then
          install_mqtt
        else
          sudo apt install -y $package
        fi
      done
      echo "Do you want to install another package? (y/n)"
      read another_choice
      if [[ $another_choice != "y" && $another_choice != "Y" ]]; then
        break
      fi
    fi
  done
}

# Function to download and extract plugin repos
install_plugins() {
  while true; do
    echo "Enter the numbers of the plugin repos you want to install (separated by spaces, or type 'all' to install all repos):"
    read -a selected_repos
    if [[ "${selected_repos[@]}" == "all" ]]; then
      echo "Choose the installation path (0: custom, 1: installed, 2: available):"
      read path_choice
      for repo in "${repos[@]}"; do
        wget $repo -P /tmp
        unzip /tmp/$(basename $repo) -d ${paths[$path_choice]}
      done
      break
    else
      echo "Choose the installation path (0: custom, 1: installed, 2: available):"
      read path_choice
      for repo_index in "${selected_repos[@]}"; do
        wget ${repos[$repo_index]} -P /tmp
        unzip /tmp/$(basename ${repos[$repo_index]}) -d ${paths[$path_choice]}
done
      echo "Do you want to install another plugin repo? (y/n)"
      read another_choice
      if [[ $another_choice != "y" && $another_choice != "Y" ]]; then
        break
      fi
    fi
  done
}

# Function for system control options
system_control() {
  echo "Choose a system control option:"
  echo "1: Restart pwnagotchi"
  echo "2: Reboot"
  echo "3: Shutdown"
  echo "4: Restart in auto"
  echo "5: Restart in manual"
  read choice
  case $choice in
    1)
      sudo systemctl restart pwnagotchi
      ;;                                                                                                                                  2)
      sudo reboot
      ;;
    3)
      sudo shutdown now
      ;;
    4)
      sudo touch /root/.pwnagotchi-auto && systemctl restart pwnagotchi
      ;;
    5)
      sudo touch /root/.pwnagotchi-manu && systemctl restart pwnagotchi
      ;;
    *)
    echo "Invalid choice"
      ;;                                                        esac                                                        }

# Define the packages to install
packages=(
  "msmtp"
  "msmtp-mta"
  "mailutils"
  "mpack"                                                       "hcxtools"
  "johntheripper"
  "wireshark"
  "surfshark"
  "openvpn"
  "wireguard"                                                   "python"
  "inotify-tools"                                               "vagrant"
  "virtualbox"
  "wordninja"
  "tabulate"
  "MQTT"
)

# Define the plugin repos and paths
repos=(
  "https://github.com/evilsocket/pwnagotchi-plugins-contrib/archive/master.zip"
  "https://github.com/PwnPeter/pwnagotchi-plugins/archive/master.zip"
  "https://github.com/Teraskull/pwnagotchi-community-plugins/archive/master.zip"
  "https://github.com/itsdarklikehell/pwnagotchi-plugins/archive/refs/heads/master.zip"
)
paths=(
  "/usr/local/share/pwnagotchi/custom-plugins"
  "/usr/local/share/pwnagotchi/installed-plugins"
  "/usr/local/share/pwnagotchi/available-plugins"
)

# Update package list
update_package_list

# List all packages and ask if the user wants to install any
list_packages
echo "Do you want to install any packages? (y/n)"
read install_pkg_choice
if [[ $install_pkg_choice == "y" || $install_pkg_choice == "Y" ]]; then
  install_packages
fi

# List all plugin repos and ask if the user wants to install any
list_repos
echo "Do you want to install any plugin repos? (y/n)"
read install_repo_choice
if [[ $install_repo_choice == "y" || $install_repo_choice == "Y" ]]; then
  install_plugins
fi

# System control options
system_control

echo "Thank you! Brought to you by BThomas22x of Cobra_Dev. BThomas22x@gmail.com -- email if you have anything to contribute!"














  



        
