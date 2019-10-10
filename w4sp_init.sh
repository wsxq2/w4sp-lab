#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


wget -O /etc/apt/sources.list https://raw.githubusercontent.com/wsxq2/MyProfile/master/Linux/Kali/etc/apt/sources.list

#echo '# for X11
#grep -q " host$" /etc/hosts && export DISPLAY="host:0.0"
#' >> ~/.bashrc

#wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add
sed -i 's#https://#http://#' /etc/apt/sources.list
apt update
apt install apt-transport-https ca-certificates -y
sed -i 's#http://#https://#' /etc/apt/sources.list
apt install ntpdate -y
ntpdate pool.ntp.org

apt install tree curl info ncat nload -y

apt upgrade -y
apt install linux-headers-$(uname -r) -y

[[ ! -d /etc/docker/ ]] && mkdir /etc/docker/
echo '{
        "iptables": true,
        "registry-mirrors": ["http://dockerhub.azk8s.cn"]
}
' > /etc/docker/daemon.json

id w4sp-lab || (echo 'so create user w4sp-lab' && useradd -mU -s /bin/bash -G sudo,wireshark -p '$6$teB23uhk$mUIdkn2Gby0viZxfexKSXTnc6leh1qGdtljSVSQkAKk3kzpTmcVYk/.h6TWJxFm2GtQZ1Wa3rHDlIZgrjT9nX.' w4sp-lab)

sed -i '/apt.dockerproject.org/s/^#//'  /etc/apt/sources.list
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D

su - w4sp-lab -c 'cd ~ && [[ ! -d w4sp-lab/ ]] && git clone https://github.com/wsxq2/w4sp-lab.git'

