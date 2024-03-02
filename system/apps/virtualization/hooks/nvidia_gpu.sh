#!/usr/bin/env bash

# Helpful to read output when debugging
set -x

# Note: apps can be launched with NVIDIA GPU via nvidia-offload %app%

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1

# Stop display manager to release GPU
# systemctl stop display-manager.service

# Unload VFIO-PCI Kernel Driver
# Nothing is using secondary GPU, so it's safe to just load it
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Load nvidia drivers
# While "modeset" is recommended, it seems to work just fine without it,
# and makes apps/services to not use dGPU by default, which also makes
# switching back to vfio without restart easier
modprobe nvidia
#modprobe nvidia_modeset
modprobe nvidia_drm modeset=0
modprobe nvidia_uvm

# Start display manager on new GPU
# systemctl start display-manager.service
