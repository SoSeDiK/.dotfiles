#!/usr/bin/env bash

# Helpful to read output when debugging
#set -x
export DISPLAY=:0

# Load the config file with our environmental variables
VIRSH_GPU_VIDEO=pci_0000_01_00_0
VIRSH_GPU_AUDIO=pci_0000_01_00_1

# nvidia-smi | grep 'python' | awk '{ print $3 }' | xargs -n1 kill -9

unload_module() {
    local module_name=$1

    # Check if the module is currently in use
    if lsmod | grep -q $module_name; then
        echo "Module $module_name is currently in use."

        # Get PIDs of processes using the module
        pids=$(fuser -v /dev/$module_name[0-9]* | awk '{print $0}')
        if [ -n "$pids" ]; then
            echo "Killing processes using $module_name..."
            echo "[ $pids ]"
            kill -9 $pids
        else
            echo "No processes found using $module_name."
        fi

        # Get PIDs and process names of processes using the module
        # local processes=$(lsof -n -c $module_name 2>/dev/null | awk '!/\/$/ && NR>1 {print $2, $1, $9}' | sort -u)
        # if [ -n "$processes" ]; then
        #     echo "Processes using $module_name:"
        #     echo "$processes"
            
        #     # Extract PIDs for killing processes
        #     local pids=$(echo "$processes" | awk '{print $1}')

        #     # Kill the processes
        #     echo "Killing processes using $module_name..."
        #     echo "[ $pids ]"
        #     #kill -9 $pids
        # else
        #     echo "No processes found using $module_name."
        # fi

        # Unload the module
        echo "Unloading $module_name..."
        modprobe -r $module_name
    else
        echo "Module $module_name is not currently loaded."
    fi
}

# Stop display manager to release GPU
# systemctl stop display-manager.service

# Unload Nvidia drivers
unload_module nvidia_drm
unload_module nvidia_modeset
unload_module nvidia_uvm
unload_module nvidia

# Load VFIO kernel modules
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

# Detach GPU to VFIO Driver
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Start display manager on new GPU
# systemctl start display-manager.service
