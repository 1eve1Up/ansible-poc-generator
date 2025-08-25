#!/bin/bash

## Bash script for installing AAP on rhel 8.5 Azure vm. This assumes that AAP is copied to the /tmp directory ##

# Create a new GPT partition table on /dev/sdc and a single xfs partition occupying the entire disk
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%

# Create an xfs filesystem on the new partition
sudo mkfs.xfs /dev/sdc1

# Create a new directory to mount the partition
sudo mkdir /datadrive

# Mount the new partition to the /datadrive directory
sudo mount /dev/sdc1 /datadrive

# Get the UUID of the new partition
UUID=$(sudo blkid -s UUID -o value /dev/sdc1)

# Add an entry to /etc/fstab to mount the partition at boot
echo "UUID=${UUID} /datadrive xfs defaults 0 0" | sudo tee -a /etc/fstab

# Move the Ansible tarball to the /datadrive directory
sudo mv /tmp/ansible-automation-platform-setup-bundle-2.1.2-1.tar.gz /datadrive/

# Extract the Ansible tarball in the /datadrive directory
sudo tar xvf /datadrive/ansible-automation-platform-setup-bundle-2.1.2-1.tar.gz -C /datadrive/

# Change to the extracted Ansible directory
cd /datadrive/ansible-automation-platform-setup-bundle-2.1.2-1/

# Edit the inventory file to set the required passwords and Red Hat registry credentials
sudo vi inventory

# Unmount the /tmp directory
sudo umount /tmp

# Resize the /tmp logical volume to 10G
sudo lvresize -L 10G /dev/rootvg/tmplv

# Run the Ansible setup script
sudo ./setup.sh
