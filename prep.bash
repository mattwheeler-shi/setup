#!/usr/bin/env bash

apt update
apt -y upgrade
apt -y install perl* wireshark-common tcpdump tshark ethtool

mkdir /opt/threatReplayer
cd /opt/threatReplayer
git clone https://github.com/mattwheeler-shi/setup.git
mv setup/* /opt/threatReplayer
tar -xzvf ./TPR_v1.3.5.tgz
mkdir /PCAPS
cd /
git clone https://github.com/mattwheeler-shi/2009-2013.git
git clone https://github.com/mattwheeler-shi/Demo_Pcaps.git
mv /Demo_Pcaps/PCAPS/* /PCAPS
mv /2009-2013/* /PCAPS