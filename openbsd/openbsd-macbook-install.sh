#!/bin/bash


# openbsd full disk encryption macbook 
#=====================================


# download install56.iso for your architecture i386 or amd64
# burn install56.iso to a disk
# restart computer, insert disk, press c to boot from cd




# openbsd encrypted drive
#========================



# press s to drop in the shell from the installer
#==================================================


# fdisk

fdisk -i wd0


# add disklabel

disklabel -E sd0


# create swap partition

a b

2 gig

# create the root partition

a a

# use the entire disk
size *


w

q


# encrypt drive
#==================================================

bioctl -c C -l /dev/wd0a softrad0

exit


# start installer
#==================================================

i


# create user

# start ntpd


# select sd0 to install on 

# press w to use whole disk to create partitions

# press e to edit partitions


# delete the swap partition on sd0

d b

# write partition table

w

q


# add your users to the sudoers file
#==================================================

# switch to root

su

# use visudo to edit the sudoers file

visudo



# add you username to the file
djwilcox ALL=(ALL) ALL


# save and exit

:wq



# add pkg path to your profile
#==================================================

# edit ~/.profile

vi ~/.profile


export PKG_PATH=ftp://ftp.openbsd.org/pub/OpenBSD/5.6/packages/$(uname -m)/


# source ~/.profile

. ~/.profile


# check PKG_PATH

echo $PKG_PATH



# install xfce packages

sudo pkg_add -i xfce4-session gtk-xfce-engine xfdesktop xfwm4 xfce4-panel xfce4-notifyd xfce4-settings
thunar xfwm4-themes xfce4-terminal

# choose gnupg as dependiency



sudo pkg_add -i  xfce4-appfinder xfce4-mixer xfce4-power-manager 



sudo pkg_add -i gvfs-mtp gvfs-smb

# choose samba as dependiency



# firefox youtube-dl vim gstreamer-plugins-ugly mplayer ubuntu-fonts xfconf xfsprogs


# macbook touchpad right click
#====================================================


# press shift and click on the touchpad button to get a right click 


# open keyboard from the application menu
# switch to layout tab
# uncheck use system defaults

# change keyboard model to: Generic 104-key pc
# change keyboard layout to: English (UK) English (UK, Macintosh)


# create /etc/X11/xorg.conf.d directory

sudo mkdir -p /etc/X11/xorg.conf.d


# create 00-keyboard.conf to remap ctrl and cmd on the mac


sudo vi /etc/X11/xorg.conf.d/00-keyboard.conf


Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "gb"
        Option "XkbModel" "pc104"
        Option "XkbVariant" "mac"
        Option "XkbOptions" "altwin:ctrl_win"
	Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection




# pf firewall
#====================================================


cd /etc

sudo mv pf.conf pf.conf.orig


sudo vi /etc/pf.conf


set block-policy drop
set skip on lo0
match in all scrub (no-df)
antispoof quick for (egress)
block in quick on egres from { no-route urpf-failed } to any
block in all
pass out quick inet keep state




# /etc/rc.conf.local
#========================

sudo vi /etc/rc.conf.local


multicast_host="YES"
ntpd_flags="-s"
pkg_scripts="dbus_daemon avahi_daemon"
sshd_flags="NO"
apmd_flags="-C"
unbound_flags="-c /var/unbound/etc/unbound.conf"




# resource linits
#========================

# /etc/login.conf


sudo vi /etc/login.conf


# change datasize-max=1512M
# change datasize-cur=1512M


# fstab
#========================

sudo vim /etc/fstab

# add ,noatime to / and /home /tmp



# fonts and themes
#========================

# fonts directory

mkdir -p ~/.local/share/fonts


# themes directory 

mkdir ~/.themes


# icons
#========================


sudo mkdir -p /usr/share/icons

# copy Faience to /usr/share/icons



# toad
#=========================


# pkg_add toad
sudo /etc/rc.d/toad start
sudo /etc/rc.d/hotplugd start


Try to insert a USB disk and access it.

ls /run/media/username/usb0/



# packages to install
#===================================

sudo pkg_add i zip unzip firefox vlc

sudo pkg_add i evince 
# evince - you want to update your font path for /usr/local/share/ghostscripts/fonts

sudo pkg_add i git
# chose rysnc as a dependency

sudo pkg_add i wget mplayer nano ristretto youtube-dl
sudo pkg_add i ngrep nmap mousepad

sudo pkg_add -i vim

# choose 1 to install gvim
