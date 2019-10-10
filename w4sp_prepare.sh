#!/usr/bin/env bash

# This scrpit is used for do some preparation work for execute `sudo python w4sp_webapp.py`.
# It is used in Kali, applicable to new or old environment


set -euo pipefail
IFS=$'\n\t'

#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3 RETURN
#exec 1>log.out 2>&1

# if need debuging, uncomment the following line
#set -x

declare -i USER_ERROR LOGNAME_ERROR CONFIG_ERROR ARGUMENTS_ERROR
USER_ERROR=1
LOGNAME_ERROR=2
CONFIG_ERROR=3
ARGUMENTS_ERROR=4

declare -A CHECK_UBUNTU_SOURCES_LIST_URL=(["xidian"]="http://linux.xidian.edu.cn/mirrors/ubuntu/" ["tuna"]="http://mirrors.tuna.tsinghua.edu.cn/ubuntu/" ["aliyun"]="http://mirrors.aliyun.com/ubuntu/")

function check_user() {
	if [ $USER != 'root' ]
	then
		echo "Please login with root and direct run, or login with w4sp-lab and run with sudo!"
		exit $USER_ERROR
	fi

	login_name=$(logname)
	if [ $login_name = 'root' ] || [ $login_name != 'w4sp-lab' ]
	then
		try_create_user_w4splab
		echo "Please login with w4sp-lab and run this script again(sudo bash $0)"
		exit $LOGNAME_ERROR
	fi
}

function try_create_user_w4splab(){
	id w4sp-lab || (echo 'create user w4sp-lab' && useradd -mU -s /bin/bash -G sudo,wireshark -p '$6$teB23uhk$mUIdkn2Gby0viZxfexKSXTnc6leh1qGdtljSVSQkAKk3kzpTmcVYk/.h6TWJxFm2GtQZ1Wa3rHDlIZgrjT9nX.' w4sp-lab)
}

function config_apt(){
	wget -O /etc/apt/sources.list https://raw.githubusercontent.com/wsxq2/MyProfile/master/Linux/Kali/etc/apt/sources.list
	#wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add
	sed -i 's#https://#http://#' /etc/apt/sources.list
	apt update
	apt install apt-transport-https ca-certificates -y
	sed -i 's#http://#https://#' /etc/apt/sources.list

	# add docker source
	sed -i '/apt.dockerproject.org/s/^#//'  /etc/apt/sources.list
	apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D
}

function set_display(){
	echo '# for X11
	grep -q " host$" /etc/hosts && export DISPLAY="host:0.0"
	' >> /etc/profile.d/custom.sh
}

function sync_network_time(){
	apt install ntpdate -y
	ntpdate pool.ntp.org
}

function install_ilike_tools(){
	apt install tree curl info ncat nload -y
}

function prepare_guest_addition(){
	apt upgrade -y
	apt install linux-headers-$(uname -r) -y
}

function check_config(){
	echo "start check config.sh..."
	# PIP_INDEX_URL
	curl -4 -Is -m5 "$PIP_INDEX_URL" > /dev/null || (echo "ERROR_CONFIG: PIP_INDEX_URL($PIP_INDEX_URL)" && exit $CONFIG_ERROR)
	
	# DOCKER_REGISTRY_MIRROR
	curl -4 -Is -m5 "$DOCKER_REGISTRY_MIRROR" > /dev/null || (echo "ERROR_CONFIG: DOCKER_REGISTRY_MIRROR($DOCKER_REGISTRY_MIRROR)" && exit $CONFIG_ERROR)
	
	# PROXY
	curl -4 -Is -m5 -x $PROXY "http://packages.elastic.co/" > /dev/null || (echo "ERROR_CONFIG: PROXY($PROXY)" && exit $CONFIG_ERROR)
	
	# UBUNTU_SOURCES_LIST
	curl -4 -Is -m5 ${CHECK_UBUNTU_SOURCES_LIST_URL["$UBUNTU_SOURCES_LIST"]} > /dev/null || (echo "ERROR_CONFIG: UBUNTU_SOURCES_LIST($UBUNTU_SOURCES_LIST)" && exit $CONFIG_ERROR)

	echo "check config.sh finished!"
}

function apply_config(){
	echo 'start apply config...'
	find . -type f -name Dockerfile |xargs grep -l PIP_INDEX_URL | xargs sed -i -e "/PIP_INDEX_URL/s##$PIP_INDEX_URL#g"

	# PROXY
	find . -type f -name Dockerfile |xargs grep -l PROXY | xargs sed -i -e "/PROXY/s##$PROXY#g"
	echo "Acquire::http::Proxy::packages.elastic.co \"$PROXY\";
Acquire::http::Proxy::ppa.launchpad.net \"$PROXY\";
Acquire::http::Proxy::apt.dockerproject.org \"$PROXY\";
" > /etc/apt/apt.conf.d/01proxy

	[[ ! -d /etc/docker/ ]] && mkdir /etc/docker/
	echo "{
	\"iptables\": true,
	\"registry-mirrors\": [\"$DOCKER_REGISTRY_MIRROR\"]
}
" > /etc/docker/daemon.json

	cp -v images/base/sources.list.$UBUNTU_SOURCES_LIST images/base/sources.list

	echo 'apply config finished!'
}

function new(){
	declare -i start_time phase1_time phase2_time end_time total_time
	start_time=$(date +%s)
	check_user
	config_apt
	end_time=$(date +%s)

	phase1_time=$(($end_time-$start_time))
	echo "before sync_network_time cost $phase1_time s"
	sync_network_time
	start_time=$(date +%s)

	install_ilike_tools
	#prepare_guest_addition

	config

	end_time=$(date +%s)
	phase2_time=$(($end_time-$start_time))
	echo "after sync_network_time cost $phase2_time s"
	total_time=$(($phase1_time+$phase2_time))
	echo "total cost $total_time s"

	echo 'all preparation work has been done. please run `sudo python w4sp_webapp.py`'
}

function config(){
	echo 'config start'

	source config.sh
	check_config
	apply_config

	echo 'config finished'
}

function print_usage_and_exit(){
	echo "Usage: bash $0 {new|config|create_user}"
	exit $ARGUMENTS_ERROR
}

function test_(){
	source config.sh
	check_config
}


function main(){
	[[ $# -ne 1 ]] && print_usage_and_exit
	case "$1" in
		new )
			new
			;;
		config)
			config
			;;
		create_user)
			# check_user include create_user
			check_user
			;;
		*)
			print_usage_and_exit
	esac
}

main "$@"
#test_
