#!/usr/bin/env bash
# Helpful to read output when debugging
set -x

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1
#source ~/.dotfiles/system/apps/virtualization/hooks/kvm.conf

unload_module() {
    local module_name=$1

    # Check if the module is currently in use
    if lsmod | grep -q $module_name; then
        echo "Module $module_name is currently in use."

        # Get PIDs of processes using the module
        local pids=$(lsof | awk -v mod="$module_name" '$0~mod {print $2}')

        if [ -n "$pids" ]; then
            echo "Processes using $module_name: $pids"
            
            # Kill the processes
            echo "Killing processes using $module_name..."
            kill -9 $pids
        else
            echo "No processes found using $module_name."
        fi

        # Unload the module
        echo "Unloading $module_name..."
        modprobe -r $module_name
    else
        echo "Module $module_name is not currently loaded."
    fi
}

# Stop display manager (seems to not work without this)
#systemctl stop display-manager.service

# Unbind VT consoles
# echo 0 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
# echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
# echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind # needed?

# Unload all Nvidia drivers
unload_module nvidia_drm
unload_module nvidia_modeset
unload_module nvidia_uvm
unload_module nvidia

# Re-Bind GPU to VFIO Driver
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Load VFIO kernel module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

# Restart Display Manager
#systemctl start display-manager.service
