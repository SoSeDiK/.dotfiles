#!/usr/bin/env bash

# Helpful to read output when debugging
set -x
export DISPLAY=:0

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1

# nvidia-smi | grep 'python' | awk '{ print $3 }' | xargs -n1 kill -9

# Stop display manager to release GPU
# systemctl stop display-manager.service

# Unload Nvidia drivers
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

# Load VFIO kernel modules
modprobe vfio vfio_pci vfio_iommu_type1

# Detach GPU to VFIO Driver
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Start display manager on new GPU
# systemctl start display-manager.service
