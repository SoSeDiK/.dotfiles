#!/usr/bin/env bash
# Helpful to read output when debugging
set -x

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1
#source ~/.dotfiles/system/apps/virtualization/hooks/kvm.conf

# # Function to stop a process by PID
# stop_process() {
#   if [ -n "$1" ]; then
#     echo "Stopping process with PID $1"
#     sudo kill -9 "$1"
#   fi
# }

# # Identify and stop processes using Nvidia modules
# stop_processes() {
#   local module_name="$1"
#   local processes=$(lsof | grep "$module_name" | awk '{print $2}' | sort -u)

#   if [ -n "$processes" ]; then
#     for pid in $processes; do
#       stop_process "$pid"
#     done
#   else
#     echo "No processes using $module_name found."
#   fi
# }

# Stop display manager (since most of the things are using the secondary GPU)
systemctl stop display-manager.service

# Unbind VT consoles
# echo 0 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
# echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
# echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind # needed?

# stop_processes "nvidia_uvm"
# stop_processes "nvidia_drm"
# stop_processes "nvidia_modeset"
# stop_processes "nvidia"

# Unload all Nvidia drivers
modprobe -r nvidia_uvm
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia

# Avoid a race condition by waiting a couple of seconds. This can be calibrated to be shorter or longer if required for your system
sleep 5

# Unbind the GPU from display driver
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Load VFIO kernel module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

# Restart Display Manager
systemctl start display-manager.service
