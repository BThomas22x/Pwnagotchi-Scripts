#!/bin/bash

# Directory containing the handshakes
DIR="/root/handshakes"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
    echo "Directory $DIR does not exist."
    exit 1
fi

# List all files in the directory with numbers
echo "List of handshakes:"
FILES=("$DIR"/*)
for i in "${!FILES[@]}"; do
    echo "$((i+1)). ${FILES[i]##*/}"
done

# Prompt the user to enter the numbers of files to delete
echo "Enter the numbers of the handshakes you want to delete (separated by spaces):"
read -r INPUT

# Convert the input into an array
IFS=' ' read -r -a NUMBERS <<< "$INPUT"

# Delete the selected files
for NUMBER in "${NUMBERS[@]}"; do
    INDEX=$((NUMBER-1))
    if [ -e "${FILES[$INDEX]}" ]; then
        echo "Deleting ${FILES[$INDEX]##*/}"
        sudo rm "${FILES[$INDEX]}"
    else
        echo "Invalid number: $NUMBER"
    fi
done

echo "Deletion completed."
echo "©2024 - Cobra_Dev -- BThomas22x & CoryHoke1"
