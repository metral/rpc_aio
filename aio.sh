#!/bin/bash

# Test that the user is root
if [ "$(id -u)" -ne "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Update repos & install deps
apt-get update && apt-get install curl cpu-checker -y

# Set virtualization type - use kvm if supported, if not, qemu
SUPPORTS_VIRT=`egrep -c '(vmx|svm)' /proc/cpuinfo`
KVM_OK=`kvm-ok`
EXISTS="kvm exists"

if [ "$SUPPORTS_VIRT" -ge "1" ] && [ "${KVM_OK/$EXISTS}" != "$KVM_OK" ]; then
   export VIRT_TYPE="kvm"
else
   export VIRT_TYPE="qemu"
fi

# Setup passwords
export PASSWORD="password"

# Add Some default Images
#export UBUNTU_IMAGE=True

# Install Rackspace Private Cloud
#curl -skS -L https://github.com/rcbops/ansible-lxc-rpc/blob/master/scripts/cloudserver-aio.sh | bash
./cloudserver-aio.sh
