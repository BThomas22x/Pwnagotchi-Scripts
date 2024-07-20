#!/bin/bash

# Function to display all handshakes with numbering
list_handshakes() {
  echo "Listing all handshakes in /root/handshakes:"
  ls -1 /root/handshakes | nl
}

# Function to confirm deletion
confirm_deletion() {
  read -p "Are you sure you want to delete the selected files>
  if [[ "$confirm" == "yes" ]]; then
    for file in "${files_to_delete[@]}"; do
      sudo rm -f "/root/handshakes/$file"
      echo "Deleted $file"
      echo "©2024 Cobra_Dev -- BThomas22x"
    done
  else
    echo "Deletion cancelled."
  fi
}

# Check if the directory exists
if [ ! -d "/root/handshakes" ]; then
  echo "/root/handshakes directory does not exist."
  exit 1
fi

# List all handshakes
list_handshakes

# Prompt for action
echo "Select an option:"
echo "1. Delete a single file"
echo "2. Delete multiple files"
echo "3. Delete all files"
read -p "Enter your choice (1/2/3): " choice

case $choice in
  1)
    read -p "Enter the number of the file you want to delete:>
    file_to_delete=$(ls -1 /root/handshakes | sed -n "${file_>
    if [ -z "$file_to_delete" ]; then
      echo "Invalid file number."
      exit 1
    fi
    files_to_delete=("$file_to_delete")
    ;;
  2)
    read -p "Enter the numbers of the files you want to delet>
    files_to_delete=()
    for number in $file_numbers; do
      file_to_delete=$(ls -1 /root/handshakes | sed -n "${num>
      if [ -z "$file_to_delete" ]; then
        echo "Invalid file number: $number"
        exit 1
      fi
      files_to_delete+=("$file_to_delete")
    done
    ;;
  3)
    files_to_delete=($(ls -1 /root/handshakes))
    ;;
  *)
  echo "Invalid choice."
    exit 1
    ;;
esac

# Confirm deletion
confirm_deletion
