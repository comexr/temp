#!/bin/bash

sudo sh -c 'sudo cp hda-jack-retask.fw /lib/firmware/'
sudo sh -c 'sudo cp hda-jack-retask.conf /etc/modprobe.d/'
echo "Script complete, changes will take effect on reboot"
