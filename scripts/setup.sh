#!/bin/bash

# Update package list
echo "Updating package lists.."
sudo apt update -y -qq

# List of tools to install
TOOLS=("git" "curl" "wget" "htop" "tree" "jq")

# Loop through each tool and install it separately
for TOOL in "${TOOLS[@]}"
do
echo "-------------------"
echo "Installing $TOOL..."
echo "-------------------"
sudo apt install -y "$TOOL" -qq
echo "------------------------------"
echo "Tool $TOOL has been installed."
done

echo "All steps completed successfully!"


