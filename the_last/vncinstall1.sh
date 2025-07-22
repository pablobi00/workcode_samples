#!/bin/bash

# Install TightVNC and GNOME Desktop 2021.03.31
# On desktop execute:
# $ ssh -L 59000:localhost:5901 -C -N -l username your_server_ip
# MAC ---> $ ssh -i <server_key> -L 5901:127.0.0.1:5901 -N -f -l <username> <server_address>
# In safari --> vnc://localhost:5901

printf "\e[0;36m\n===== [OS Update] ===========================================\n\e[0m"

sudo apt -y update
sudo apt list --upgradable
sudo apt -y full-upgrade

sleep 10

printf "\e[0;36m\n===== [Desktop/VNC Server] ===========================================\n\e[0m"

sudo apt -y install gnome-session gdm3
sudo apt -y install tightvncserver -y

sleep 10

printf "\e[0;36m\n===== [Create startup file] ===========================================\n\e[0m"

vncserver
vncserver kill :1
cp ~/.vnc/xstartup ~/.vnc/xstartup.bak

printf '#!/bin/bash
xrdb $HOME/.Xresourcesup
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession
gnome-session &\n' > ~/.vnc/xstartup 

chmod +x ~/.vnc/xstartup
vncserver -geometry 1280x1024

printf "\e[0;36m\n
Service started.\n
To stop type: \"$ vncserver -kill :1\"
To start again type: \"$ vncserver -geometry 1280x1024\"\n\e[0m"

printf "\e[0;36m\n===== [EOF] ==============\n\e[0m"
