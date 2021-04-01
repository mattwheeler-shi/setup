#!/bin/bash

#git clone https://github.com/mattwheeler-shi/threatReplayer.git
sudo apt update
sudo apt upgrade
sudo apt -y install wireshark-common tshark tcpdump perl* build-essential ethtool
sudo mkdir /opt/threatReplayer
sudo mkdir /home/results
sudo mkdir /home/results/archive
sudo mkdir /PCAPS
sudo mv Demo/* /PCAPS/
sudo mv * /opt/threatReplayer
cd /opt/threatReplayer
sudo tar -xzvf TPR_v*
sudo chmod a+x *.bash
#  ./install
#  ./install
#  ./miniSrv
ls -l