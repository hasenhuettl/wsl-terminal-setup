#!/bin/bash

set -e

cd
sudo apt-get update
sudo apt-get upgrade -y
oldhostname="$(hostname)"
# Take the new hostname as an input param!
newhostname="$(whoami)-wsl"
tar xf /mnt/c/…/tmux.tar.bz2
echo -e "[network]\nhostname=${newhostname}\ngenerateHosts=false" | sudo tee /etc/wsl.conf

# Set DNS server ips: 
echo -e "nameserver 1.1.1.1\nnameserver 4.4.4.4\n" | sudo tee /etc/resolv.conf
echo -e "\ngenerateResolvConf=false" | sudo tee -a /etc/wsl.conf

sudo sed -i "s/$oldhostname/$newhostname/g" /etc/hosts
sed -i "s/replace_with_your_hostname/$newhostname/g" /etc/hosts
sudo locale-gen --purge en_US.UTF-8
echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | sudo tee /etc/default/locale

# exit