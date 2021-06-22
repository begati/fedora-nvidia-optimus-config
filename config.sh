#!/usr/bin/bash
# Description: Nvidia Optimus installer and configuration for Fedora (tested on 34).
# Author: Evandro Begati
# Date: 2021/06/22

# Verify for sudo/root execution
if [ "$EUID" -ne 0 ]
  then echo "Please, run this script with sudo."
  exit
fi

# Enable RPM Fusion
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Update the system
dnf update -y

## Install the Nvidia driver

# Install akmod-nvidia
dnf install gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 -y

# Install CUDA
dnf install xorg-x11-drv-nvidia-cuda -y

# Finalize config
akmods --force
dracut --force

# Set Nvidia GPU as default display output
cp -p /usr/share/X11/xorg.conf.d/nvidia.conf /etc/X11/xorg.conf.d/nvidia.conf
sudo sed -i '/Identifier "nvidia"/i Option "PrimaryGPU" "yes"' /etc/X11/xorg.conf.d/nvidia.conf

# Press any key to reboot
clear
read -p "Press any key to reboot..." temp </dev/tty

# Bye :)
reboot