#!/usr/bin/env bash
VM="win11"
virsh --connect qemu:///system start $VM
