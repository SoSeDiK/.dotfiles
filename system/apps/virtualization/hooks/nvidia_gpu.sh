#!/usr/bin/env bash
# Helpful to read output when debugging
set -x

# Note: apps can be launched with Nvidia GPU via nvidia-offload %app%

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1
#source ~/.dotfiles/system/apps/virtualization/hooks/kvm.conf

# Unload VFIO-PCI Kernel Driver
# Nothing is using secondary GPU, so it's safe to just load it
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Rebind VT consoles
# echo 1 > /sys/class/vtconsole/vtcon0/bind
# echo 0 > /sys/class/vtconsole/vtcon1/bind

# Read our nvidia configuration when before starting our graphics
#nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# Re-Bind EFI-Framebuffer
# echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind # needed?

# Load nvidia drivers
# While "modeset" is recommended, it seems to work just fine without it,
# and makes apps/services to not use dGPU by default, which also makes
# switching back to vfio without restart easier
modprobe nvidia
#modprobe nvidia_modeset
modprobe nvidia_drm modeset=0
modprobe nvidia_uvm

# Restart Display Manager
#systemctl restart display-manager.service
