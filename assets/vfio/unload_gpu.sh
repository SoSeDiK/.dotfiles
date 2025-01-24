#!/usr/bin/env bash

# Helpful to read output when debugging
set -x
export DISPLAY=:0

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1

# Stop display manager to release GPU
# systemctl stop display-manager.service

# Unload Nvidia drivers
sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

# Unload VFIO-PCI Kernel Driver
modprobe -r vfio_pci vfio_iommu_type1 vfio

# Detach GPU
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Start display manager on new GPU
# systemctl start display-manager.service
