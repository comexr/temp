#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run script as root"
    exit
fi
cat <<EOF > /etc/pm/sleep.d/20_touchpad_reset
case "\${1}" in
    thaw)
        rmmod hid_multitouch
        modprobe hid_multitouch
;;
esac
EOF
echo "Created touchpad reset script"
sudo chmod +x /etc/pm/sleep.d/20_touchpad_reset || exit 1

cat <<EOF > /lib/systemd/system/touchpad-reset.service
[Unit]
Description=Reset multitouch device after hibernate
After=hibernate.target
After=hybrid-sleep.target
After=suspend.target
[Service]
ExecStart=/bin/bash /etc/pm/sleep.d/20_touchpad_reset thaw
[Install]
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target
WantedBy=suspend.target
EOF
echo "Created systemd service file"
sudo systemctl enable touchpad-reset.service || exit 1
echo "Script finished, please reboot"
exit 0

