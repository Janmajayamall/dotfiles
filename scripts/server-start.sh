#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary tools for C++ development
echo "Installing necessary tools for C++ development..."
sudo apt-get install -y clang cmake

# Install additional utilities
echo "Installing additional utilities..."
sudo apt-get install -y curl wget unzip git bc
