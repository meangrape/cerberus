#!/bin/bash


# qemu install
#===============================================

sudo pacman -S qemu libvirt bridge-utils openbsd-netcat virt-manager 

sudo pacman -S dnsmasq


# check hardware support
lscpu

# check if kvm modules are loaded
zgrep CONFIG_KVM /proc/config.gz

# check if virtio modules are loaded
zgrep CONFIG_VIRTIO /proc/config.gz

# Loading kernel modules
# First, check if the kernel modules are automatically loaded

lsmod | grep kvm
lsmod | grep virtio


# In case the above commands return nothing, 
# you need to load kernel modules






# Create PolicyKit authorization file for kvm group
#==================================================


# create /etc/polkit-1/rules.d/49-org.libvirt.unix.manager.rules


sudo vim /etc/polkit-1/rules.d/49-org.libvirt.unix.manager.rules


/* Allow users in kvm group to manage the libvirt
daemon without authentication */
polkit.addRule(function(action, subject) {
    if (action.id == "org.libvirt.unix.manage" &&
        subject.isInGroup("kvm")) {
            return polkit.Result.YES;
    }
});



# restart polkit service
#===============================================

sudo systemctl restart polkit.service



# create the kvm group and add your user to it
#===============================================

# replace username with your username

sudo groupadd kvm
sudo gpasswd -a username kvm





# set up networking
#===============================================


sudo pacman -S ebtables



# check ethernet device name

ip a

# the ethernet device is usually called eth0
# my ethernet device is called ens9

# if your ethernet is called eth0, 
# replace ens9 with eth0 in the commands below




# set ethernet device down 

sudo ip link set dev ens9 down



# create the bridge

sudo brctl addbr br0



# Add a device to a bridge

sudo brctl addif br0 ens9



# show bridges

brctl show



# set ethernet device up 

sudo ip link set up dev ens9



# Set the bridge device up:

sudo ip link set up dev br0



# Delete a bridge, 
# you need to first set it to down:


sudo ip link set dev br0 down
sudo brctl delbr br0



# Allow qemu to access to the bridge br0
#===============================================


# copy the bridge.conf.sample and rename to bridge.conf

sudo cp /etc/qemu/bridge.conf.sample /etc/qemu/bridge.conf



# Enable IPv4 forwarding:
#===============================================

sudo sysctl net.ipv4.ip_forward=1





# start / enable libvirtd at boot
#===============================================


# start libvirtd 

sudo systemctl start libvirtd


# enable libvirtd at boot

sudo systemctl enable libvirtd


# start libvirt socket if needed
sudo systemctl start virtlogd.socket


sudo systemctl enable virtlogd.socket


# Test if libvirt is working properly 
#===============================================


# To test if the daemon is working properly on a system level:

virsh -c qemu:///system


# the virsh prompt looks like this:

virsh #




# To test if libvirt is working properly for a user-session: 

virsh -c qemu:///session




# create a storage pool file directory in your home directory
#============================================================


# create a directory for the libvirt storage pool
# replace username with your username

mkdir -p /home/username/libvirt/images


# chown the libvirt directory to allow both your user and the kvm group access
# replace username with your username

sudo chown -R username:kvm /home/username/libvirt



# set acl for libvirt

setfacl -m "u:nobody:--x" /home/djwilcox


getfacl /home/djwilcox


chmod o-rx /home/djwilcox



# home directory file permissions
#===============================================

chmod o+x /home/username



# change libvirt default storage pool directory
#===============================================


# list pools
sudo virsh pool-list --all


# stop default pool
sudo virsh pool-destroy default

# remove default pool
sudo virsh pool-undefine default


# create new pool
sudo virsh pool-define-as --name default --type dir --target /home/username/libvirt/images 

# start the new pool
sudo virsh pool-start default

# autostart the new pool
sudo virsh pool-autostart default




# libvirt commands
#===============================================


# list pools

sudo virsh pool-list --all



# virsh pool-dumpxml

sudo virsh pool-dumpxml default 



# Stopping a Pool

sudo virsh pool-destroy poolname



# Remove the storage pools definition

sudo virsh pool-undefine poolname



# Starting a Pool

sudo virsh pool-start poolname



# Enable Autostarting a Pool

sudo virsh pool-autostart poolname



# Verify that the storage pool was created correctly and is running

sudo virsh pool-info poolname




# install openbsd
#====================


# live cd
#==========

qemu-system-x86_64 -cdrom cd56.iso -m 256

qemu-system-x86_64 -net nic -net bridge,br=br0 -cdrom cd56.iso -m 256



# install openbsd to img file
#=============================


# cd into the storage pool directory

cd ~/libvrt/images


# create a 10 gig image file to use as a hard drive

qemu-img create openbsd.img 10G



# run qemu with a network bridge, hard drive and cdrom

qemu-system-x86_64 \
-net nic -net bridge,br=br0 \
-hda openbsd.img \
-cdrom cd56.iso \
-boot d \
-m 1024



# run qemu without cd rom

qemu-system-x86_64 \
-net nic -net bridge,br=br0 \
-hda openbsd.img \
-m 1024



