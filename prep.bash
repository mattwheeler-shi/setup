#!/bin/bash

apt update
apt upgrade
apt install perl* wireshark-common tcpdump tshark ethtool
mkdir /opt/threatReplayer
cd /opt/threatReplayer
git clone https://github.com/mattwheeler-shi/setup.git
mv setup/* /opt/threatReplayer
chmod 775 /opt/threatReplayer/*.bash
chmod a+x /opt/threatReplayer/*.bash
tar -xzvf ./TPR_v1.3.5.tgz
mkdir /PCAPS
cd /
git clone https://github.com/mattwheeler-shi/2009-2013.git
git clone https://github.com/mattwheeler-shi/Demo_Pcaps.git
mv /Demo_Pcaps/PCAPS/* /PCAPS
mv /2009-2013/* /PCAPS
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
echo
echo
echo
echo
echo "Reboot"
echo
echo
echo "After reboot, change the /etc/netplan file, then  sudo netplan generate, sudo netplan apply "
echo
echo " And run   sudo ip link set eth1 promisc on && sudo ip link set eth2 promisc on"
echo
echo
echo
