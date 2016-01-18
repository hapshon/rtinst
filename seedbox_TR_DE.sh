#!/bin/bash
#########################################################################
# File Name: ONEKEY2014.sh
# Author: LookBack
# mail: admin@dwhd.org
# Created Time: 2014年 04月 07日 星期一 15:41:57 CST
# Last Edit: 2015年 06月 15日 星期一 21:58:12 CST
# Author: LaiBoKe.com
# Last Edit: 2015 年 06月 29日 星期一 19:35:06 CST
#########################################################################
#================================================================
ONEKEY_LOGO="
    E E E E E E E E E  E   D D D  D			W						W						W   I I I I II I I I I    N 			 N
	E		 			  D	        D	     W					   W W					   W			II			  N	N	         N
    E 					  D			  D		  W				      W   W				 	  W				II			  N	  N          N
	E					  D			    D	   W				 W	   W				 W				II			  N	   N         N
	E					  D			     D	    W			    W	    W			    W	            II			  N	    N        N
	E					  D				  D		 W			   W     	 W			   W		    	II			  N	     N       N
	E E E E E E E E E E E D				  D		  W			  W      	  W			  W	            	II			  N		  N	     N
	E					  D				  D		   W		 W       	   W		 W              	II			  N		   N     N
	E					  D		         D  		W		W        		W		W               	II			  N		    N    N
	E					  D             D       	 W	   W             	 W	   W                	II			  N			 N   N
	E					  D		       D		 	  W	  W          	 	  W	  W						II			  N			  N  N
	E					  D  	     D		 		   W W            		   W W 			    I I I I II I I I I    N			   N N
	E E E E E E E E E E E  D D D D  D						            			                                                
	"
	Modfiy Form军团、Laboke
#================================================================
# 避免在更改源之前apt-get install执行失败，先进行更新源
  apt-get update
#================================================================
ONE_KEY_NAME=`basename $0`
ONE_KEY_FILE=`pwd`
APTITUDE_CHECK=`which aptitude`
BASH_CHECK=`ls -l $(which sh) | grep bash`
if [ -e "$ONE_KEY_NAME" ]; then
	rm -rf $ONE_KEY_FILE/$ONE_KEY_NAME
else
	find / -name $ONE_KEY_NAME | xargs rm -rf
fi
if [ -z "$BASH_CHECK" ]; then
	dpkg-reconfigure dash
fi
if [ -z "$APTITUDE_CHECK" ]; then
	apt-get install aptitude -y
fi
#================================================================
echo=echo
for cmd in echo /bin/echo; do
		$cmd >/dev/null 2>&1 || continue
		if ! $cmd -e "" | grep -qE '^-e'; then
			echo=$cmd
			break
		fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CQUESTION="$CMAGENTA"
CWARNING="$CRED"
CMSG="$CCYAN"
#================================================================
if [ $(id -u) != "0" ]; then
    echo "警告: 你现在不是root权限登录服务器, 请使用root帐号登录服务器，然后执行SEEDBOX军团的一键安装脚本~！"
    exit 1
fi
mkdir -p /tmp/ONEKEY && cd /tmp/ONEKEY

#================================================================
ONEKEY_DOWNLOAD_LINK="http://sh.laiboke.com/box"
ONEKEY_WEB_LINK="www.dwhd.org"
ONEKEY_ADMIN_EMAIL="admin@dwhd.org"
ONEKEY_TIME="$(date)"
ONEKEY_NEWUSER_DIRECTORY="/home/hapshon/transmission"
ONEKEY_FLEXGET_DIRECTORY="/root/.flexget"
ONEKEY_ONLINE_INSTALL="aptitude install"
ONEKEY_SCCREN_DELUGE="screen -fa -d -m -S deluge-web deluge-web"
ONEKEY_CRONTAB_ROOT="/var/spool/cron/crontabs/root"
ONEKEY_OPENDIR=`cat /etc/security/limits.conf | grep '65535'`
ONEKEY_OVH_CHECK1=`hostname | cut -d. -f2`
ONEKEY_OVH_CHECK2=`hostname | grep '^ns' | grep '.eu$'`
ONEKEY_OVH_CHECK3=`hostname | grep '^ns' | grep '.net$'`
ONEKEY_YUAN=`cat /etc/apt/sources.list | grep '^[^#]' | awk -F ' ' '{print $3}' | awk 'NR<2'`
ONEKEY_RC_LOCAL="/etc/rc.local"
ONEKEY_ADD_SOURCES="/etc/apt/sources.list"
ONEKEY_OS_BIT=$(getconf LONG_BIT)
ONEKEY_OS="/root/os.txt"
ONEKEY_TR_CONFIG="/etc/transmission-daemon/settings.json"
ONEKET_TR_START="/etc/init.d/transmission-daemon"
ONEKEY_TR277="transmission-daemon"
ONEKEY_VNSTAT="/var/www/vnstat"
blockHDWing="n"
ONEKEY_RTDIR="/var/rutorrent/rutorrent"
ONEKEY_RTDOWN="/root/rut"
ONEKEY_V="V20140407版"
#================================================================

detectOs() {
	local DISTRIB_ID=
	local DISTRIB_DESCRIPTION=
	if [ -f /etc/lsb-release ]; then
		. /etc/lsb-release
	fi

	if [ -f /etc/fedora-release ]; then
		os=fedora
		os_long="$(cat /etc/fedora-release)"
	# Must be before PCLinuxOS, Mandriva, and a whole bunch of other OS tests
	elif [ -f /etc/unity-release ]; then
		os=unity
		os_long="$(cat /etc/unity-release)"
	elif [ -f /etc/pclinuxos-release ]; then
		os=pclinuxos
		os_long="$(cat /etc/pclinuxos-release)"
	elif [ "$DISTRIB_ID" = "Ubuntu" ]; then
		os=debian
		os_long="$DISTRIB_DESCRIPTION"
	elif [ "$DISTRIB_ID" = "LinuxMint" ]; then
		os=debian
		os_long="$DISTRIB_DESCRIPTION"
	# Must be before Debian
	elif [ "$DISTRIB_ID" = "Peppermint" ]; then
		os=debian
		os_long="$DISTRIB_DESCRIPTION"
	elif [ "$DISTRIB_ID" = "MEPIS" ]; then
		os=debian
		os_long="$DISTRIB_DESCRIPTION"
	elif [ -f /etc/clearos-release ]; then
		os=fedora
		os_long="$(cat /etc/clearos-release)"
	elif [ -f /etc/pardus-release ]; then
		os=pardus
		os_long="$(cat /etc/pardus-release)"
	elif [ -f /etc/chakra-release ]; then
		os=arch
		os_long="Chakra $(cat /etc/chakra-release)"
	elif [ -f /etc/frugalware-release ]; then
		os=frugalware
		os_long="$(cat /etc/frugalware-release)"
	# Must test this before Gentoo
	elif [ -f /etc/sabayon-release ]; then
		os=sabayon
		os_long="$(cat /etc/sabayon-release)"
	elif [ -f /etc/arch-release ]; then
		os=arch
		os_long="Arch Linux"
	elif [ -f /etc/gentoo-release ]; then
		os=gentoo
		os_long="$(cat /etc/gentoo-release)"
	elif [ -f /etc/SuSE-release ]; then
		os=opensuse
		os_long="$(grep SUSE /etc/SuSE-release | head -n1)"
	elif [ -f /etc/debian_version ]; then
		os=debian
		local prefix=
		if ! uname -s | grep -q GNU; then
			prefix="GNU/"
		fi
		os_long="Debian $prefix$(uname -s) $(cat /etc/debian_version)"
	# Must test for mandriva before centos since it also has /etc/redhad-release
	elif [ -f /etc/mandriva-release ]; then
		os=mandriva
		os_long="$(cat /etc/mandriva-release)"
	elif [ -f /etc/redhat-release ]; then
		os=fedora
		os_long="$(cat /etc/redhat-release)"
	elif [ -f /etc/vector-version ]; then
		os=slaptget
		os_long="VectorLinux $(cat /etc/vector-version)"
	elif [ -f /etc/slackware-version ]; then
		if isProgramInstalled slapt-get; then
			os=slaptget
			os_long="$(cat /etc/slackware-version)"
		else
			os=other
			os_long="$(cat /etc/slackware-version)"
		fi
	elif [ $(uname -s) = "FreeBSD" ]; then
		os=freebsd
		os_long=FreeBSD
	elif [ $(uname -s) = "DragonFly" ]; then
		os=dragonfly
		os_long="DragonFly BSD"
	elif [ $(uname -s) = "OpenBSD" ]; then
		os=openbsd
		os_long=OpenBSD
	elif [ $(uname -s) = "NetBSD" ]; then
		os=netbsd
		os_long=NetBSD
	else
		os=other
		os_long="$(uname -s)"
	fi

	os_long="${os_long:-$(uname -s)}"
}

detectOs
ONEKEY_DEBIAN_VERSION=`echo $os_long | grep 'Debian'`
ONEKEY_UBUNTU_VERSION=`echo $os_long | grep 'Ubuntu'`
ONEKEY_UBUNTU_1004=`echo $os_long | grep 'Ubuntu 10.04'`
ONEKEY_UBUNTU_1110=`echo $os_long | grep 'Ubuntu 11.10'`
ONEKEY_UBUNTU_1204=`echo $os_long | grep 'Ubuntu 12.04'`
ONEKEY_UBUNTU_1210=`echo $os_long | grep 'Ubuntu 12.10'`
ONEKEY_UBUNTU_1304=`echo $os_long | grep 'Ubuntu 13.04'`
ONEKEY_UBUNTU_1310=`echo $os_long | grep 'Ubuntu 13.10'`
ONEKEY_UBUNTU_1404=`echo $os_long | grep 'Ubuntu 14.04'`
ONEKEY_UBUNTU_1504=`echo $os_long | grep 'Ubuntu 15.04'`
#================================================================
isValidIpAddress() {
	echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$'
}
getIpAddress() {
	isValidIpAddress "$OUR_IP_ADDRESS" && return
	echo "${CMSG}开始检测IP地址...结果有1%的错误机率...$CEND"
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s curlmyip.com)
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s ip.cn | awk -F'：' '{print $2}' | awk '{print $1}')
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s http://v4.ipv6-test.com/api/myip.php)
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s ifconfig.me)
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s http://checkip.dyndns.org | awk '{print $6}' | awk 'BEGIN { FS = "<" } { print $1 }')
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g')
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(wget -q -O - checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(ifconfig | awk -F'[ ]+|:' '/inet addr/{if($4!~/^192\.168|^172\.16|^10\.|^127|^0/) print $4}')
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS=$(wget -q --no-check-certificate http://www.whatismyip.com/automation/n09230945.asp -O - -o /dev/null)
	isValidIpAddress "$OUR_IP_ADDRESS" || OUR_IP_ADDRESS="1.2.3.4"
}

#================================================================
ONEKEY_MAIN_MEN() {
	dialog --no-shadow --colors --title "SEEDBOX军团一键脚本 $ONEKEY_V" \
	--menu "\Zb\Z3请问是否继续运行脚本来安装BT软件从而实现盒子环境架设?点击鼠标左键选择你需要的选项就OK " 100 200 10 \
	"1" "\Zb\Z1安装 Deluge+Flexget" \
	"2" "\Zb\Z1安装 rTorrent+ruTorrent" \
	"3" "\Zb\Z1安装 Transmission+Flexget" \
	"4" "\Zb\Z6安装 FTP" \
	"5" "\Zb\Z6安装 VPN" \
	"6" "\Zb\Z6配置 VNC" \
	"7" "\Zb\Z5创建SSH代理" \
	"8" "\Zb\Z5修改时区为中国大陆时区" \
	"9" "\Zb\Z5一键配置Flexget (可以一键配置 中国5大站RSS)" \
	"10" "\Zb\Z5安装 Rapidleech " 2>/tmp/MAINMEN
}
ONEKEY_RSS_MEN() {
	dialog --no-shadow --colors --title "SEEDBOX军团一键脚本 $ONEKEY_V" \
	--menu "\Zb\Z3请问是否继续运行脚本来配置支持国内五大站的RSS设置？\n本脚本可以一键设置中国CHD HDW TTG HDR (HDS)网站的RRS订阅。\n您也可以在后期在后期自己手动设置RSS " 100 200 2 \
	"1" "\Zb\Z1一键配置 Deluge RSS (支持国内五大站)" \
	"2" "\Zb\Z1一键配置 Transmission RSS (支持国内五大站)" 2>/tmp/RSSMEN
	rssmen=`cat /tmp/RSSMEN`
}
		
ONEKEY_DELUGE_MEN() {
	dialog --no-shadow --colors --title "SEEDBOX军团一键脚本 $ONEKEY_V" \
	--menu "\Zb\Z3请问是否继续运行脚本来安装Deluge？\n友情提示:CHD网站已不再支持Deluge的使用。" 100 200 2 \
	"1" "\Zb\Z1一键安装Deluge1.3.5版" \
	"2" "\Zb\Z1一键安装Deluge最新版本" 2>/tmp/DELUGEMEN
}

ONEKEY_TRANSMISSION_MEN() {
	dialog --colors --title "SEEDBOX军团一键脚本 $ONEKEY_V" \
	--menu "\Zb\Z3请问是否继续运行脚本来安装Transmission？\n友情提示国内有几个网站不再支持Transmission2.82。\n为了您正常使用建议安装Transmission2.77版。" 100 200 2 \
	"1" "\Zb\Z1一键安装Transmission2.77版 (需要是Ubuntu1204以上版本)" \
	"2" "\Zb\Z1一键安装Transmission最新版 (各种Ubuntu系统版本会不一样)" 2>/tmp/TRANSMISSIONMEN
}

Flexget_Question1() {
	dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "\Zb\Z2Flexget安装菜单" --yesno "\Zb\Z4如果需要安装Flexget请选择:\n\Zb\Z1<是>\Zb\Z3或者\Zb\Z1<yes>\n\n\Zb\Z4不希望安装请选择:\n\Zb\Z1<否>\Zb\Z3或者\Zb\Z1<no>" 15 60
	flexget=$?
}

TransmissionZH_Question() {
	dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "\Zb\Z2Transmission中文WEBGUI安装菜单" --yesno "\Zb\Z4如果需要安装Transmission中文WEBGUI请选择:\n\Zb\Z1<是>\Zb\Z3或者\Zb\Z1<yes>\n\n\Zb\Z4不希望安装请选择:\n\Zb\Z1<否>\Zb\Z3或者\Zb\Z1<no>" 15 60 2>/tmp/Transmissionzh
	transmissionzh=$?
}

Flexget_Question_Conf() {
	dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "\Zb\Z1是否配置马上配置Flexget" --yesno "\Zb\Z4如果需要现在就配置Flexget请选择:\n\Zb\Z1<是>\Zb\Z3或者\Zb\Z1<yes>\n\n\Zb\Z4不需要马上配置请选择:\n\Zb\Z1<否>\Zb\Z3或者\Zb\Z1<no>" 15 60 2>/tmp/conf_flexgetQA
	conf_flexgetQA=$?
}

USERNAM_MENU() {
	dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "用户名设置"  --inputbox "请在下面输入需要的用户名:(默认:box123)" 8 50 "box123" 2>/tmp/username
}

USER_PASSWORD() {
	passwd=`date +%s | sha256sum | base64 | head -c 8`
	dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:LookBack 联系:admin@dwhd.org" --title "密码选项" --insecure --passwordbox "请输入需要设置的密码:(默认为8位随机密码)\n\Zb\Z1为了帐号安全建议使用随机密码\Zb\Zn\n使用随机密码直接回车就OK" 8 50 "$passwd" 2>/tmp/userpassword
}

WAIT_TIME() {
	for I in {1..100}; do sleep 0.02; echo $I;done | dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --gauge "脚本在后台运行中请等待......." 7 100
}

GONG_GA0() {
	dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "\Zb\Z1公告" --msgbox "脚本会对系统做一些必要的优化、\n安装一些必要的配合软件或软件配置的更改、\n但是本脚本不会在用户系统中留下后门或者木马，\n\n\n请按回车键继续运行" 10 50
}

#================================================================
exit_scrip() {
		exit_scrip="y"
		echo ""
		echo "${CWARNING} 是否继续执行脚本?$CEND"
		echo "${CGREEN}默认按任意键退出执行,如果需要继续执行脚本请按输入n 然后回车:$CEND"
		read exit_scrip
		case "$exit_scrip" in
		y|Y|Yes|YES|yes|yES|yEs|YeS|yeS)
		echo "${CYELLOW}退出SEEDBOX军团一键脚本 !感谢您的使用!$CEND"
		exit_scrip="y"
		;;
		n|N|No|NO|no|nO)
		echo "${CYELLOW}继续执行脚本!$CEND"
		exit_scrip="n"
		;;
		*)
		echo "${CYELLOW}输入错误,退出SEEDBOX军团一键脚本!感谢您的使用!$CEND"
		exit_scrip="y"
		esac
		if [ $exit_scrip = "n" ]; then
			printf "\033c"
			men
		else
			rm -rf /root/*.sh && printf "\033c"
			source /root/.bashrc && rm -rf /root/os.txt
		fi
}

men() {
		while :
		do
		ONEKEY_MAIN_MEN
		input=`cat /tmp/MAINMEN`
		history -w && history -c
		if [ "$input" = "1" -o "$input" = "a" -o "$input" = "A" ]; then
			printf "\033c"
			ONEKEY_DELUGE_MEN
			deluge=`cat /tmp/DELUGEMEN`
			if [ "$deluge" = "1" -o "$deluge" = "A" -o "$deluge" = "a" ]; then
				install_deluge135
			elif [ "$deluge" = "2" -o "$deluge" = "B" -o "$deluge" = "b" ]; then
				install_deluge
			else
				printf "\033c" && echo ""
				echo "${CQUESTION}              输入错误返回菜单 $CEND"
				sleep 1
				men
			fi
			exit_scrip
			break
		elif [ "$input" = "2" -o "$input" = "b" -o "$input" = "B" ]; then
			printf "\033c"
			install_rtorrent
			exit_scrip
			break
		elif [ "$input" = "3" -o "$input" = "c" -o "$input" = "C" ]; then
			if [ -n "$ONEKEY_UBUNTU_VERSION" ]; then
				printf "\033c"
				echo "${CWARNING}脚本检测到您的系统是Ubuntu,开始进入子选项$CEND" && sleep 2
				ONEKEY_TRANSMISSION_MEN
				transmission=`cat /tmp/TRANSMISSIONMEN`
				if [ "$transmission" = "1" -o "$transmission" = "A" -o "$transmission" = "a" ]; then
					install_transmissionub
				elif [ "$transmission" = "2" -o "$transmission" = "B" -o "$transmission" = "b" ]; then
					install_transmission
				else
					printf "\033c" && echo ""
					echo "${CQUESTION}              输入错误返回菜单 $CEND"
					sleep 1
					men
				fi
			elif [ -n "ONEKEY_DEBIAN_VERSION" ]; then
				printf "\033c"
				install_transmission
			else
				printf "\033c" && echo ""
				echo "${CQUESTION}              判断出错返回菜单 $CEND"
				sleep 1
				men
			fi
			exit_scrip
			break
		elif [ "$input" = "4" -o "$input" = "d" -o "$input" = "D" ]; then
			printf "\033c"
			install_ftp
			exit_scrip
			break
		elif [ "$input" = "5" -o "$input" = "e" -o "$input" = "E" ]; then
			printf "\033c"
			install_vpn
			exit_scrip
			break
		elif [ "$input" = "6" -o "$input" = "f" -o "$input" = "F" ]; then
			printf "\033c"
			install_vnc 
			exit_scrip
			break
		elif [ "$input" = "7" -o "$input" = "g" -o "$input" = "G" ]; then
			printf "\033c"
			install_ssh_proxy
			exit_scrip
			break
		elif [ "$input" = "8" -o "$input" = "h" -o "$input" = "H" ]; then
			printf "\033c"
			change_time
			exit_scrip
			break
		elif [ "$input" = "9" -o "$input" = "i" -o "$input" = "I" ]; then
			printf "\033c"
			ONEKEY_RSS_MEN
			rss=`cat /tmp/RSSMEN`
			if [ "$rss" = "1" -o  "$rss" = "A" -o "$rss" = "a" ]; then
				install_flexget
				deflexget_config
			elif [ "$rss" = "2" -o "$rss" = "B" -o "$rss" = "b" ]; then
				install_flexget
				trflexget_config
			else
				printf "\033c" && echo ""
				echo "${CQUESTION}              不配置任何RSS返回菜单 $CEND"
				sleep 1
				men
			fi
			exit_scrip
			break
		elif [ "$input" = "10" -o "$input" = "j" -o "$input" = "J" ]; then
			printf "\033c"
			install_rapidleech
			exit_scrip
			break
		else
			printf "\033c" && rm -rf /root/*.sh && printf "\033c"
			echo "${CQUESTION}对不起!!!!! 脚本开始退出.........................$CEND"
			sleep 2;echo "Bye Bye";printf "\033c"
			echo "${CQUESTION}Shell 脚本运行结束时间: $CGREEN$ONEKEY_TIME$CEND"
			exit
		fi
		done
}
#================================================================
TransmissionConfig() {
	cat > $ONEKEY_TR_CONFIG << EOF
{
    "alt-speed-down": 50,
    "alt-speed-enabled": false,
    "alt-speed-time-begin": 540,
    "alt-speed-time-day": 127,
    "alt-speed-time-enabled": false,
    "alt-speed-time-end": 1020,
    "alt-speed-up": 50,
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": false,
    "blocklist-url": "http://www.example.com/blocklist",
    "cache-size-mb": 400,
    "dht-enabled": false,
    "download-dir": "/home/hapshon/transmission/downloads/",
    "download-limit": 10000,
    "download-limit-enabled": 0,
    "download-queue-enabled": false,
    "download-queue-size": 50,
    "encryption": 1,
    "idle-seeding-limit": 30,
    "idle-seeding-limit-enabled": false,
    "incomplete-dir": "/home/hapshon/transmission/incomplete/",
    "incomplete-dir-enabled": false,
    "lazy-bitfield-enabled": false,
    "lpd-enabled": false,
    "max-peers-global": 20000,
    "message-level": 2,
    "open-file-limit": 65535,
    "peer-congestion-algorithm": "",
    "peer-limit-global": 880,
    "peer-limit-per-torrent": 800000,
    "peer-port": 51413,
    "peer-port-random-high": 65535,
    "peer-port-random-low": 49152,
    "peer-port-random-on-start": false,
    "peer-socket-tos": "default",
    "pex-enabled": true,
    "port-forwarding-enabled": false,
    "preallocation": 1,
    "prefetch-enabled": 1,
    "proxy": "",
    "proxy-auth-enabled": false,
    "proxy-auth-password": "",
    "proxy-auth-username": "",
    "proxy-enabled": false,
    "proxy-port": 80,
    "proxy-type": 0,
    "queue-stalled-enabled": false,
    "queue-stalled-minutes": 30,
    "ratio-limit": 20,
    "ratio-limit-enabled": false,
    "rename-partial-files": false,
    "rpc-authentication-required": true,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-password": "$trpasswd",
    "rpc-port": 9091,
    "rpc-url": "/transmission/",
    "rpc-username": "$trname",
    "rpc-whitelist": "127.0.0.1",
    "rpc-whitelist-enabled": false,
    "scrape-paused-torrents-enabled": true,
    "script-torrent-done-enabled": false,
    "script-torrent-done-filename": "",
    "seed-queue-enabled": false, 
    "seed-queue-size": 10, 
    "speed-limit-down": 100,
    "speed-limit-down-enabled": false,
    "speed-limit-up": 100,
    "speed-limit-up-enabled": false,
    "start-added-torrents": true,
    "trash-original-torrent-files": true,
    "umask": 0,
    "upload-limit": 10000,
    "upload-limit-enabled": 0,
    "upload-slots-per-torrent": 100,
    "utp-enabled": true,
    "watch-dir": "/home/hapshon/transmission/trrss/",
    "watch-dir-enabled": true
}
EOF
}
#================================================================
install_deluge135() {
		printf "\033c" && echo "${CYELLOW}开始安装Deluge1.3.5及相关软件...............................$CEND"
		sleep 2
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/downloads/
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/rss/
		mkdir -p $ONEKEY_FLEXGET_DIRECTORY
		apt-get autoremove --purge mysql* -y
		apt-get update&&apt-get upgrade -y
		$ONEKEY_ONLINE_INSTALL -y python-twisted python-twisted-web2 python-openssl python-simplejson python-pip python-xdg python-chardet python-geoip python-libtorrent python-notify python-pygame python-gtk2 python-gtk2-dev python-mako gettext intltool  librsvg2-dev xdg-utils
		$ONEKEY_ONLINE_INSTALL -y mktorrent unrar* screen bizp2
		$ONEKEY_ONLINE_INSTALL vnstat
		printf "\033c" && echo "${CYELLOW}程序继续运行中$CEND"
		mkdir -p /root/.config/deluge
		GEOIP=$(find / -name GeoIP -type d)
		cd $GEOIP && rm -rf GeoIP.dat GeoIPv6.dat
		wget -N -c -q -O $GEOIP/GeoLiteCityv6.dat.gz http://sh.laiboke.com/laiboke/downloads/GeoLiteCityv6.dat.gz
		wget -N -c -q -O $GEOIP/GeoIP.dat.gz http://sh.laiboke.com/laiboke/downloads/GeoIP.dat.gz
		#wget -N -c -q -O $GEOIP/GeoLiteCityv6.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
		#wget -N -c -q -O $GEOIP/GeoIP.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
		gzip -d GeoIP.dat.gz && gzip -d GeoLiteCityv6.dat.gz && cd $ONE_KEY_FILE
		wget -q -O /root/deluge-1.3.5.tar $ONEKEY_DOWNLOAD_LINK/deluge-1.3.5.tar
		tar -xf deluge-1.3.5.tar
		cd deluge-1.3.5 && python setup.py clean -a
		python setup.py install
		cd && rm -rf build
		rm -rf $ONEKEY_OS deluge-*
		deluged
		$ONEKEY_SCCREN_DELUGE
		sed -i 's/^exit 0$/deluged\nscreen -fa -d -m -S deluge-web deluge-web\nexit 0/' $ONEKEY_RC_LOCAL
		killall deluged
		for I in {1..100}; do sleep 0.05; echo $I;done | dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 V140301 作者:SEEDBOX军团 联系:admin@dwhd.org" --gauge "Deluge设置后台运行中请等待......." 7 100
		killall deluged
		wget -q -O /root/.config/deluge/core.conf $ONEKEY_DOWNLOAD_LINK/core.conf
		deluged
		vnstat -u -i eth0
		printf "\033c"
		Flexget_Question1
		if [ "$flexget" = "0" ]; then
			mkdir -p $ONEKEY_FLEXGET_DIRECTORY
			install_flexget
			Flexget_Question_Conf
			if [ "$conf_flexgetQA" = "0" ]; then
				deflexget_config
			fi
			printf "\033c"
		fi
		WAIT_TIME
		ONEKEY_DELUGE_PASS=`awk -F ':' '{print $2}' /root/.config/deluge/auth`
		ONEKEY_DELUGE_USERNAME=`awk -F ':' '{print $1}' /root/.config/deluge/auth`
		printf "\033c"
		getIpAddress
		printf "\033c" && cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   Deluge安装结束，下面是Deluge的相关信息$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 你的Deluge 登录地址        :$CGREEN http://$OUR_IP_ADDRESS:8112 $CEND
		${CQUESTION}= 你的Deluge 登录密码        :$CGREEN deluge$CEND
		${CQUESTION}= 你的Deluge 下载路径        :$CGREEN $ONEKEY_NEWUSER_DIRECTORY/downloads$CEND
		${CQUESTION}= Deluge pass                :$CGREEN $ONEKEY_DELUGE_PASS$CEND
		${CQUESTION}= Deluge Username            :$CGREEN $ONEKEY_DELUGE_USERNAME$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}

install_deluge() {
		printf "\033c" && echo "${CYELLOW}开始安装Deluge及相关软件...............................$CEND"
		sleep 2
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/downloads/
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/rss/
		mkdir -p $ONEKEY_FLEXGET_DIRECTORY
		GEOIP=$(find / -name GeoIP -type d)
		cd $GEOIP && rm -rf GeoIP.dat GeoIPv6.dat
		wget -N -c -q -O $GEOIP/GeoLiteCityv6.dat.gz http://sh.laiboke.com/laiboke/downloads/GeoLiteCityv6.dat.gz
		wget -N -c -q -O $GEOIP/GeoIP.dat.gz http://sh.laiboke.com/laiboke/downloads/GeoIP.dat.gz
		#wget -N -c -q -O $GEOIP/GeoLiteCityv6.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
		#wget -N -c -q -O $GEOIP/GeoIP.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
		gzip -d GeoIP.dat.gz && gzip -d GeoLiteCityv6.dat.gz && cd $ONE_KEY_FILE
		if [ -n "$ONEKEY_UBUNTU_VERSION" ]; then
			printf "\033c"
			apt-get autoremove --purge mysql* -y
			echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu jaunty main" >> $ONEKEY_ADD_SOURCES
			echo "deb-src http://ppa.launchpad.net/deluge-team/ppa/ubuntu jaunty main" >> $ONEKEY_ADD_SOURCES
			$ONEKEY_ONLINE_INSTALL vnstat
			printf "\033c"
			sed -i s/"MaxBandwidth 100"/"MaxBandwidth 1000"/g /etc/vnstat.conf
			if [ -n "$ONEKEY_UBUNTU_1004" ]; then
				chmod 777 /var/run/screen
				echo "${CQUESTION}Vnstat 安装完成~~~~~~~~~~~~~~~~~~~~~$CEND"
			else
				echo "${CQUESTION}Vnstat 安装完成~~~~~~~~~~~~~~~~~~~~~$CEND"
				printf "\033c"
			fi
			$ONEKEY_ONLINE_INSTALL mktorrent
			$ONEKEY_ONLINE_INSTALL -y unrar*
			$ONEKEY_ONLINE_INSTALL python-software-properties -y && printf "\033c"
			if [ -n "$ONEKEY_UBUNTU_1004" ]; then
				add-apt-repository ppa:deluge-team/ppa
			else
				add-apt-repository -y ppa:deluge-team/ppa
			fi
			apt-get update -y
			$ONEKEY_ONLINE_INSTALL screen deluged deluge-web -y
		elif [ -n "$ONEKEY_DEBIAN_VERSION" ]; then
			echo "nameserver 8.8.8.8" > /etc/resolv.conf
			echo "nameserver 8.8.4.4" >> /etc/resolv.conf
			echo "${CYELLOW}开始安装Deluge...............................$CEND"
			rm -rf $ONEKEY_FLEXGET_DIRECTORY/config.yml
			echo "deb http://ftp.fr.debian.org/debian unstable main" >> $ONEKEY_ADD_SOURCES
			echo "deb-src http://ftp.fr.debian.org/debian unstable main" >> $ONEKEY_ADD_SOURCES
			wget -q -O /etc/apt/preferences $ONEKEY_DOWNLOAD_LINK/preferences
			aptitude update -y
			aptitude -t unstable install deluge -y
			echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu lucid main" >> $ONEKEY_ADD_SOURCES
			echo "deb-src http://ppa.launchpad.net/deluge-team/ppa/ubuntu lucid main" >> $ONEKEY_ADD_SOURCES
			apt-key adv --recv-keys --keyserver pgp.surfnet.nl 249AD24C
			apt-get update -y
			apt-get install -t lucid deluge-common deluged deluge-web -y
		else
			echo "${CQUESTION}Version is not Ubuntu OR Debian !!!$CEND"
			echo "${CQUESTION}Sorry!!!!! Now Quit.........................$CEND"
			echo "${CQUESTION}Shell Script Over Time: $CGREEN$ONEKEY_TIME$CEND"
		fi
		rm -rf $ONEKEY_OS
		deluged && $ONEKEY_SCCREN_DELUGE
		sed -i 's/^exit 0$/deluged\nscreen -fa -d -m -S deluge-web deluge-web\nexit 0\n/' $ONEKEY_RC_LOCAL
		killall deluged
		wget -q -O /root/.config/deluge/core.conf $ONEKEY_DOWNLOAD_LINK/core.conf
		deluged
		vnstat -u -i eth0
		printf "\033c"
		Flexget_Question1
		if [ "$flexget" = "0" ]; then
			mkdir -p $ONEKEY_FLEXGET_DIRECTORY
			install_flexget
			Flexget_Question_Conf
			if [ "$conf_flexgetQA" = "0" ]; then
				deflexget_config
			fi
			printf "\033c"
		fi
		WAIT_TIME
		ONEKEY_DELUGE_PASS=`awk -F ':' '{print $2}' /root/.config/deluge/auth`
		ONEKEY_DELUGE_USERNAME=`awk -F ':' '{print $1}' /root/.config/deluge/auth`
		printf "\033c"
		getIpAddress
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   Deluge安装结束，下面是Deluge的相关信息$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 你的Deluge 登录地址        :$CGREEN http://$OUR_IP_ADDRESS:8112 $CEND
		${CQUESTION}= 你的Deluge 登录密码        :$CGREEN deluge$CEND
		${CQUESTION}= 你的Deluge 下载路径        :$CGREEN $ONEKEY_NEWUSER_DIRECTORY/downloads$CEND
		${CQUESTION}= Deluge pass                :$CGREEN $ONEKEY_DELUGE_PASS$CEND
		${CQUESTION}= Deluge Username            :$CGREEN $ONEKEY_DELUGE_USERNAME$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}

install_rtorrent() {
		printf "\033c"
		echo "${CYELLOW}开始安装 ruTorrent...............................$CEND"
		sleep 2
		apt-get autoremove --purge apache* -y
		apt-get autoremove --purge mysql* -y
		apt-get update && apt-get upgrade -y
		$ONEKEY_ONLINE_INSTALL nano screen zip rar perl -y
		$ONEKEY_ONLINE_INSTALL libarchive-zip-perl libnet-ssleay-perl libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl -y
		$ONEKEY_ONLINE_INSTALL -y irssi
		apt-get update
		wget -q -O /root/autodl-setup $ONEKEY_DOWNLOAD_LINK/autodl-setup
		sh /root/autodl-setup
}

install_transmissionub() {
		printf "\033c"
		trdir="/usr/share/transmission"
		trgzname="transmission-control-full.tar.gz"
		downtrweb="http://sh.laiboke.com/laiboke/downloads/$trgzname" && printf "\033c"
		#downtrweb="http://transmission-control.googlecode.com/svn/resouces/$trgzname" && printf "\033c"
		printf "\033c" && echo "${CYELLOW}开始安装Transmission并配置~~$CEND" && sleep 2 && printf "\033c"
		USERNAM_MENU
		trname=$(cat /tmp/username)
		USER_PASSWORD
		trpasswd=$(cat /tmp/userpassword)
		printf "\033c"
		if [ "$1" != "" ]; then
			trpasswd=$1
		fi
		sudo useradd $trname -d /home/hapshon/transmission -m -k /n
		echo $trname:$trpasswd | chpasswd
		if [ -n "$ONEKEY_UBUNTU_1110" ] || [ -n "$ONEKEY_UBUNTU_1204" ] || [ -n "$ONEKEY_UBUNTU_1210" ] || [ -n "$ONEKEY_UBUNTU_1304" ] || [ -n "$ONEKEY_UBUNTU_1310" ] || [ -n "$ONEKEY_UBUNTU_1404" ] || [ -n "$ONEKEY_UBUNTU_1504" ]; then
			#apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libappindicator-dev
			apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libappindicator-dev openssl libssl-dev libssl0.9.8
			wget $ONEKEY_DOWNLOAD_LINK/transmission-2.77.tar.xz
			xz -d transmission-2.77.tar.xz && tar -xf transmission-2.77.tar
			cd transmission-2.77 && ./configure -q && make -s && make install && cd
			useradd -s /sbin/nologin -d /etc/transmission-daemon/ -m -k /n transmission
			wget -c -O $ONEKET_TR_START http://sh.laiboke.com/box/transmission_start_stop
			chmod +x $ONEKET_TR_START
			$ONEKET_TR_START start && sleep 3 && $ONEKET_TR_START stop
			rm -rf transmission-2.7*
		elif [ -n "$ONEKEY_UBUNTU_1004" ]; then
			apt-get install python-software-properties -y
			add-apt-repository -y ppa:transmissionbt/ppa
			apt-get update
			$ONEKEY_ONLINE_INSTALL transmission-cli $ONEKEY_TR277 transmission-common python-pip -y
			easy_install transmissionrpc
			$ONEKET_TR_START stop
		else
			echo "${CWARNING}您的Ubuntu系统 脚本无法识别版本号$CEND"
			exit
		fi
		config_transmission
		TransmissionConfig
		chown -R transmission:transmission $ONEKEY_NEWUSER_DIRECTORY/*
		mv $ONEKEY_TR_CONFIG /etc/$ONEKEY_TR277/.config/$ONEKEY_TR277/settings.json
		update-rc.d transmission-daemon defaults
		$ONEKET_TR_START start
		TransmissionZH_Question
		Flexget_Question1
		if [ "$transmissionzh" = "0" ]; then
			if [ -n "$ONEKEY_UBUNTU_1110" ] || [ -n "$ONEKEY_UBUNTU_1204" ] || [ -n "$ONEKEY_UBUNTU_1210" ] || [ -n "$ONEKEY_UBUNTU_1304" ] || [ -n "$ONEKEY_UBUNTU_1310" ] || [ -n "$ONEKEY_UBUNTU_1404" ] || [ -n "$ONEKEY_UBUNTU_1504" ]; then
				trdir=/usr/local/share/transmission/
			fi
			printf "\033c" && echo "${CYELLOW}开始配置Transmission中文界面~~$CEND" && sleep 2 && printf "\033c"
			printf "\033c" && cd $trdir && mv $trdir/web/index.html $trdir/web/index.original.html
			wget -q $downtrweb -O $trdir/$trgzname
			cd $trdir/ && tar -zxf $trgzname && cd
		fi
		printf "\033c"
		if [ "$flexget" = "0" ]; then
			mkdir -p $ONEKEY_FLEXGET_DIRECTORY
			install_flexget
			Flexget_Question_Conf
			if [ "$conf_flexgetQA" = "0" ]; then
				trflexget_config
			fi
			printf "\033c"
		fi
		printf "\033c"
		getIpAddress
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                     Transmission安装结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Transmission 登陆地址        :$CGREEN http://$OUR_IP_ADDRESS:9091$CEND
		${CQUESTION}= Transmission 用户名          :$CGREEN $trname$CEND
		${CQUESTION}= Transmission 密码            :$CGREEN $trpasswd$CEND
		${CQUESTION}= Transmission 文件下载路径    :$CGREEN /home/hapshon/transmission/downloads$CEND
		${CQUESTION}= Transmission 种子监控目录    :$CGREEN /home/hapshon/transmission/trrss$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}
install_transmission() {
		printf "\033c" && echo "${CYELLOW}开始安装Transmission并配置~~$CEND" && sleep 2 && printf "\033c"
		USERNAM_MENU
		trname=$(cat /tmp/username)
		USER_PASSWORD
		trpasswd=$(cat /tmp/userpassword)
		if [ "$1" != "" ]; then
			trpasswd=$1
		fi
		sudo useradd $trname -d /home/hapshon/transmission -m -k /n
		echo $trname:$trpasswd | chpasswd
		apt-get install python-software-properties vnstat mktorrent -y && printf "\033c"
		add-apt-repository -y ppa:transmissionbt/ppa && printf "\033c"
		apt-get update
		apt-get -y install transmission-cli transmission-daemon transmission-common python-pip
		easy_install transmissionrpc
		printf "\033c"
		config_transmission
		TransmissionConfig
		chmod -R 777 /etc/transmission-daemon/settings.json
		if [ -n "$ONEKEY_UBUNTU_VERSION" ]; then
			if [ "$ONEKEY_OS_BIT" = "64" ]; then
				wget -q http://mirror.ovh.net/ubuntu//pool/main/g/gnutls26/libgnutls26_2.12.23-1ubuntu1_amd64.deb
				wget -q http://mirror.ovh.net/ubuntu//pool/main/libt/libtasn1-3/libtasn1-3_2.14-2_amd64.deb
				dpkg -i libtasn1-3_2.14-2_amd64.deb
				dpkg -i libgnutls26_2.12.23-1ubuntu1_amd64.deb
				rm -rf *.deb && printf "\033c"
			elif [ "$ONEKEY_OS_BIT" = "32" ]; then 
				wget -q http://mirror.ovh.net/ubuntu//pool/main/g/gnutls26/libgnutls26_2.12.23-1ubuntu1_i386.deb
				wget -q http://mirror.ovh.net/ubuntu//pool/main/libt/libtasn1-3/libtasn1-3_2.14-2_i386.deb
				dpkg -i libtasn1-3_2.14-2_i386.deb
				dpkg -i libgnutls26_2.12.23-1ubuntu1_i386.deb
				rm -rf *.deb && printf "\033c"
			else
				echo "${CWARNING}脚本无法判断你的系统是32位还是64位$CEND"
			fi
			update-rc.d transmission-daemon defaults
		elif [ -n "$ONEKEY_DEBIAN_VERSION" ]; then
			insserv transmission-daemon
		else
			sleep 2 && printf "\033c"
			echo "${CQUESTION}对不起您的系统不是$CEND ${CGREEN}Ubuntu或者Debian.........................$CEND"
			echo "Bye Bye"
			echo "${CQUESTION}Shell 脚本运行结束时间: $CGREEN$ONEKEY_TIME$CEND"
			exit
		fi
		TRREBOOT=`cat ~/.bashrc | grep 'transmission-daemon'`
		if [ -z "$TRREBOOT" ]; then
			echo 'alias trreboot="/etc/init.d/transmission-daemon restart"' >> ~/.bashrc
			echo 'alias trstop="/etc/init.d/transmission-daemon stop"' >> ~/.bashrc
			echo 'alias trstart="/etc/init.d/transmission-daemon start"' >> ~/.bashrc
			seq 3|xargs -i `source /root/.bashrc`
		fi
		$ONEKET_TR_START start
		TransmissionZH_Question
		Flexget_Question1
		if [ "$transmissionzh" = "0" ]; then
			if [ -n "$ONEKEY_UBUNTU_1110" ] || [ -n "$ONEKEY_UBUNTU_1204" ] || [ -n "$ONEKEY_UBUNTU_1210" ] || [ -n "$ONEKEY_UBUNTU_1304" ] || [ -n "$ONEKEY_UBUNTU_1310" ] || [ -n "$ONEKEY_UBUNTU_1404" ] || [ -n "$ONEKEY_UBUNTU_1504" ]; then
				trdir=/usr/local/share/transmission/
			fi
			trdir="/usr/share/transmission"
			trgzname="transmission-control-full.tar.gz"
			downtrweb="http://sh.laiboke.com/laiboke/downloads/$trgzname" && printf "\033c"
			#downtrweb="http://transmission-control.googlecode.com/svn/resouces/$trgzname" && printf "\033c"
			printf "\033c" && echo "${CYELLOW}开始配置Transmission中文界面~~$CEND" && sleep 2 && printf "\033c"
			printf "\033c" && cd $trdir && mv $trdir/web/index.html $trdir/web/index.original.html
			wget -q $downtrweb -O $trdir/$trgzname
			cd $trdir/ && tar -zxf $trgzname && cd
		fi
		printf "\033c"
		if [ "$flexget" = "0" ]; then
			mkdir -p $ONEKEY_FLEXGET_DIRECTORY
			install_flexget
			Flexget_Question_Conf
			if [ "$conf_flexgetQA" = "0" ]; then
				trflexget_config
			fi
			printf "\033c"
		fi
		printf "\033c"
		getIpAddress
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                     Transmission安装结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Transmission 登陆地址        :$CGREEN http://$OUR_IP_ADDRESS:9091$CEND
		${CQUESTION}= Transmission 用户名          :$CGREEN $trname$CEND
		${CQUESTION}= Transmission 密码            :$CGREEN $trpasswd$CEND
		${CQUESTION}= Transmission 文件下载路径    :$CGREEN /home/hapshon/transmission/downloads$CEND
		${CQUESTION}= Transmission 种子监控目录    :$CGREEN /home/hapshon/transmission/trrss$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}
install_ftp() {
		printf "\033c"
		echo "${CYELLOW}开始安装FTP...............................$CEND"
		sleep 2
		$ONEKEY_ONLINE_INSTALL -y proftpd
		sed -i s/"#DefaultRoot"/"DefaultRoot"/g /etc/proftpd/proftpd.conf
		/etc/init.d/proftpd restart
		printf "\033c"
		echo "${CQUESTION}请输入一个用户名作为登陆FTP的用户名:$CEND"
		read ftpusername
		ftppassword=`date +%s | sha256sum | base64 | head -c 8`
		printf "\033c" && useradd $ftpusername
		echo $ftpusername:$ftppassword | chpasswd
		if [ "$ftpusername" = "box123" ]; then
			mkdir -p /home/$ftpusername
			chmod 777 /home/$ftpusername
		else
			mkdir -p /home/$ftpusername
			chmod 777 /home/$ftpusername
			ln -s $ONEKEY_NEWUSER_DIRECTORY/downloads/ /home/$ftpusername/
		fi
		sed -i "# DefaultRoot         ~/DefaultRoot         ~/g" /etc/proftpd/proftpd.conf
		sed -i "65 s/30/2000/" /etc/proftpd/proftpd.conf
		echo "AllowRetrieveRestart on" >> /etc/proftpd/proftpd.conf
		echo "AllowStoreRestart on" >> /etc/proftpd/proftpd.conf
		/etc/init.d/proftpd restart && printf "\033c"
		getIpAddress
		printf "\033c" && cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   FTP安装结束$CEND
		${CQUESTION}==================================================================
		${CQUESTION}= FTP IP地址       :$CGREEN $OUR_IP_ADDRESS$CEND
		${CQUESTION}= FTP 端口         :$CGREEN 21$CEND
		${CQUESTION}= FTP 用户名       :$CGREEN $ftpusername$CEND
		${CQUESTION}= FTP 密码         :$CGREEN $ftppassword$CEND
		${CQUESTION}=$CGREEN ftp://$ftpusername:$ftppassword@$OUR_IP_ADDRESS/downloads$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}

install_http() {
	if [ -n "$(ss -apl | grep 'nginx')" ]; then
		echo "Nginx 已经安装且在运行中"
	else
		mkdir /tmp/src && cd /tmp/src
		opensslURL=http://www.openssl.org/source/openssl-1.0.1i.tar.gz
		pcreUrl=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.35.tar.gz
		zlibUrl=http://zlib.net/zlib-1.2.8.tar.gz
		nginxUrl=http://nginx.org/download/nginx-1.6.2.tar.gz
		nginxProt=$(date +%s | grep -oE '[[:digit:]]{5}$')
		for i in $opensslURL $pcreUrl $zlibUrl $nginxUrl; do wget $i;done
		[ -z "$(echo `which make` | grep make)" ] && apt-get install make -y
		[ -z "$(echo `which gcc` | grep gcc)" ] && apt-get install gcc -y
		wget $ONEKEY_DOWNLOAD_LINK/nginx_init -O /etc/init.d/nginx && chmod +x /etc/init.d/nginx
		for i in openssl-1.0.1i.tar.gz pcre-8.35.tar.gz zlib-1.2.8.tar.gz nginx-1.6.2.tar.gz; do tar xf $i;done
		cd zlib-1.2.8 && ./configure --prefix=/usr/local && make -j4 && make install
		cd ../openssl-1.0.1i && ./config --prefix=/usr/local --openssldir=/usr/local/ssl && make -j4 && make install
		./config shared --prefix=/usr/local --openssldir=/usr/local/ssl && make clean && make -j4 && make install
		cd ../nginx-1.6.2 && mkdir -p /var/tmp/nginx/client
		./configure  --prefix=/usr/local/nginx --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-http_spdy_module --with-http_dav_module \
		--with-http_realip_module --with-http_gzip_static_module --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-pcre=../pcre-8.35 --with-zlib=../zlib-1.2.8 --with-debug \
		--http-client-body-temp-path=/var/tmp/nginx/client --http-proxy-temp-path=/var/tmp/nginx/proxy --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi
		make -j4 && make install && cd /usr/local/nginx/conf
		. /etc/profile.d/nginx.sh
        sed -i '/http {/a \\tautoindex on;\n\tautoindex_exact_size off;\n\tautoindex_localtime on;' nginx.conf
		sed -ri "s/(^([[:space:]])+listen\2+).*/\1$nginxProt;/" nginx.conf
		sed -ri "s/(^([[:space:]])+server_name\2+).*/\1$(hostname);/" nginx.conf
		sed -ri "s@(^([[:space:]])+root\2+).*@\1/home/hapshon/transmission/downloads;@" nginx.conf
		echo "export PATH=/usr/local/nginx/sbin/:$PATH" > /etc/profile.d/nginx.sh
		update-rc.d nginx defaults && service nginx start && rm -rf /tmp/src && printf "\033c"
		getIpAddress
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   Nginx  编译安装结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Your WEBIP 地址     :$CGREEN http://$OUR_IP_ADDRESS:$nginxProt$CEND
		${CQUESTION}= Your WEBURL 地址    :$CGREEN http://$(hostname):$nginxProt$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
	fi
}
install_vpn() {
		printf "\033c"
		echo "${CYELLOW}开始安装VPN...............................$CEND"
		sleep 2
		dpkg --purge remove pptpd
		apt-get --purge remove pptpd
		apt-get update
		printf "\033c"
		echo "${CQUESTION}请输入一个用户名作为VPN的用户名:$CEND"
		read username
		echo "${CQUESTION}请输入一个密码作为VPN的密码:$CEND"
		read password
		printf "\033c"
		$ONEKEY_ONLINE_INSTALL -y pptpd
		echo 1 > /proc/sys/net/ipv4/ip_forward
		echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
		iptables -A FORWARD -s 192.168.1.0/24 -j ACCEPT
		iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
		iptables-save > /etc/iptables-rules
		touch /etc/network/if-up.d/iptables
		cat > /etc/network/if-up.d/iptables << EOF
#!/bin/sh
iptables-restore < /etc/iptables-rules
chmod +x /etc/network/if-up.d/iptables
EOF
		PPTPD="/etc/pptpd.conf"
		CHAP="/etc/ppp/chap-secrets"
		PPTPD_OPTIONS="/etc/ppp/pptpd-options"
		rm -rf $PPTPD && touch $PPTPD
		cat > "$PPTPD" << EOF
option    /etc/ppp/pptpd-options
logwtmp
localip    192.168.1.1
remoteip    192.168.1.100-245
EOF
		rm -rf $CHAP && touch $CHAP
		echo "$username pptpd $password  \"*\"" >> $CHAP
		rm -rf $PPTPD_OPTIONS && touch $PPTPD_OPTIONS
		chmod 777 $PPTPD_OPTIONS
		cat > $PPTPD_OPTIONS << EOF
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
nodefaultroute
lock
nobsdcomp
name pptpd
EOF
		printf "\033c"
		getIpAddress
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   PPTPD VPN 安装结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Your VPN IP 地址  :$CGREEN $OUR_IP_ADDRESS$CEND
		${CQUESTION}= PPTP VPN 帐户     :$CGREEN $username$CEND
		${CQUESTION}= PPTP VPN 密码     :$CGREEN $password$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}

install_vnc() {
		printf "\033c"
		echo "${CYELLOW}开始安装VNC.................................$CEND" && sleep 2
		apt-get install vnc4server xfce4 ttf-arphic-bkai00mp ttf-arphic-bsmi00lp ttf-arphic-gbsn00lp ttf-arphic-gbsn00lp fcitx xfonts-intl-chinese -y --force-yes --fix-missing
		vncpasswd=`date +%s | sha256sum | base64 | head -c 8`
		dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:LookBack 联系:admin@dwhd.org" --title "密码选项" --insecure --passwordbox "请输入需要设置的密码:(默认为8位随机密码)\n\Zb\Z1为了帐号安全建议使用随机密码\Zb\Zn\n使用随机密码直接回车就OK" 8 50 "$vncpasswd" 2>/tmp/vncuserpassword
		inputvncpasswd=$(cat /tmp/vncuserpassword)
		vncpasswd <<EOF
$inputvncpasswd
$inputvncpasswd
EOF
		vncserver && vncserver -kill :1
		XSTARTUP="/root/.vnc/xstartup"
		rm -rf $XSTARTUP && echo "" > $XSTARTUP
		cat > $XSTARTUP << EOF
#!/bin/sh

# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# unset DBUS_SESSION_BUS_ADDRESS 

# exec /etc/X11/xinit/xinitrc

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
x-terminal-emulator -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
# x-window-manager &
x-session-manager & 
xfdesktop & xfce4-panel &     
xfce4-menu-plugin &     
xfsettingsd &     
xfconfd &     
xfwm4 &
exec ck-launch-session dbus-launch --exit-with-session startxfce4
EOF
		chmod +x $XSTARTUP
		sed -i 's/^exit 0$/su root \-c "\/usr\/bin\/vncserver \-name my-vnc-server \-geometry 1280x800 \:1"\nexit 0/' $ONEKEY_RC_LOCAL
		rm -rf /tmp/vncuserpassword && vncserver
		printf "\033c"
		getIpAddress
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   VNC安装配置结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 你的VNC 地址    :$CGREEN $OUR_IP_ADDRESS:1$CEND
		${CQUESTION}= 你的VNC 密码    :$CGREEN $inputvncpasswd$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}
install_ssh_proxy() {
		GROUP_CHECK=`cat /etc/group | grep -o fanqiang`
		if [ "$GROUP_CHECK" = "fanqiang" ]; then
			echo "$CGREEN系统中已经有了翻墙专用用户组，不再添加多余的用户组！" && sleep 2
		else
			groupadd fanqiang
		fi
		printf "\033c"
		USERNAM_MENU
		proxyusername=`cat /tmp/username`
		USER_PASSWORD
		proxypassword=`cat /tmp/userpassword`
		FQ_USER_CHECK=`cat /etc/passwd | grep -o "$proxyusername"`
		if [ -n "$FQ_USER_CHECK" ]; then
			printf "\033c" && echo "$CGREEN系统中已经有了有了一个你设置的用户，此次设置失败请重新设置！" && sleep 2
			printf "\033c" && echo "$CGREEN您之前是否已经创建过SSH代理？是否因为之前SSH代理帐号密码遗忘而导致此次重新设置SSH代理？"
			echo "$CGREEN如果是因为遗忘之前已经设置的SSH代理帐号密码，这里可以重新设置之前SSH代理帐号密码" && sleep 5
			dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "\Zb\Z1SSH代理帐号密码重装询问" --yesno "\Zb\Z4如果需要安装重置SSH代理帐号密码请选择:\n\Zb\Z1<是>\Zb\Z3或者\Zb\Z1<yes>\n\n\Zb\Z4不需要请选择:\n\Zb\Z1<否>\Zb\Z3或者\Zb\Z1<no>" 15 60
			sshproxy=$?
			if [ "$sshproxy" = "0" ]; then
				dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:SEEDBOX军团 联系:admin@dwhd.org" --title "需要重装密码的用户名设置"  --inputbox "请在下面输入需要需要重装密码的用户名:" 8 50 "$proxyusername" 2>/tmp/username
				passwd=`date +%s | sha256sum | base64 | head -c 8`
				dialog --no-shadow --colors --backtitle "\Zb\Z3SEEDBOX军团一键脚本 $ONEKEY_V 作者:LookBack 联系:admin@dwhd.org" --title "密码选项" --insecure --passwordbox "请输入新密码:(默认为8位随机密码)\n\Zb\Z1为了帐号安全建议使用随机密码\Zb\Zn\n使用随机密码直接回车就OK" 8 50 "$passwd" 2>/tmp/userpassword
				proxyusername2=`cat /tmp/username`
				proxypassword2=`cat /tmp/userpassword`
				echo $proxyusername2:$proxypassword2 | chpasswd && printf "\033c"
				rm -rf /tmp/username /tmp/userpassword
				getIpAddress && printf "\033c" && cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   SSH代理安装配置结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= SSH 代理 IP 地址  :$CGREEN $OUR_IP_ADDRESS$CEND
		${CQUESTION}= SSH 代理 帐户     :$CGREEN $proxyusername$CEND
		${CQUESTION}= SSH代理新密码     :$CGREEN $proxypassword$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
			else
				printf "\033c" && echo "$CGREEN现在返回程序主目录！" && sleep 2
				rm -rf /tmp/username /tmp/userpassword && men
			fi
		else
			useradd -d /home/$proxyusername -m -k /n -g fanqiang -s /bin/false $proxyusername
			echo $proxyusername:$proxypassword | chpasswd && printf "\033c"
			rm -rf /tmp/username /tmp/userpassword
			printf "\033c"
			getIpAddress
			printf "\033c"
			cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   SSH代理安装配置结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= SSH 代理 IP 地址  :$CGREEN $OUR_IP_ADDRESS$CEND
		${CQUESTION}= SSH 代理 帐户     :$CGREEN $proxyusername$CEND
		${CQUESTION}= SSH 代理 密码     :$CGREEN $proxypassword$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
		fi
}
change_time() {
		printf "\033c" && echo "" && echo "" && echo ""
		echo "${CQUESTION}                              请等待，脚本运行中...............$CEND"
		rm -rf /etc/localtime
		cp -a /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
		ntpdate time.windows.com
		hwclock -w
		printf "\033c"
		cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   时区修改结束 本服务器/VPS现在时区为中国大陆时区$CEND
		${CGREEN}$ONEKEY_TIME$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}
install_flexget() {
		printf "\033c"
		echo "${CYELLOW}开始检测Flexget是否安装和Flexget相关配置 ...................$CEND"
		ONEKEY_FLEXGET_FIND="/var/tmp/flexget.txt"
		ONEKEY_FLEXGET5=`find / -name FlexGet* | grep -s "FlexGet" > $ONEKEY_FLEXGET_FIND`&&sleep 2
		ONEKEY_FLEXGET6=`cat /var/tmp/flexget.txt | grep 'FlexGet'`
		sleep 2 && touch $ONEKEY_FLEXGET_FIND
		echo "" > $ONEKEY_FLEXGET_FIND
		if [ -n "$ONEKEY_FLEXGET6" ]; then
			printf "\033c" && echo "${CYELLOW}系统已安装Flexget  可以直接配置Flexget$CEND"&&sleep 3
		else
			printf "\033c" && echo "${CYELLOW}系统未安装Flexget  先进行安装Flexget$CEND"&&sleep 3
			mkdir $ONEKEY_NEWUSER_DIRECTORY/flexget/
			touch $ONEKEY_FLEXGET_DIRECTORY/config.yml
			ln -s $ONEKEY_FLEXGET_DIRECTORY/config.yml $ONEKEY_NEWUSER_DIRECTORY/flexget/config.yml
			$ONEKEY_ONLINE_INSTALL -y python-pip
			pip install -Iv https://pypi.python.org/packages/source/t/tmdb3/tmdb3-0.7.1.tar.gz#md5=a3de16b84747ddec0e40c5a54cb17173
			pip install flexget
			#if ! which flexget; then
			#	wget -q 'http://www.dwhd.org.box/tmd3setup.py' -O ./build/tmdb3/setup.py && chmod +x ./build/tmdb3/setup.py
			#	pip install flexget
			#fi
		fi
		touch $ONEKEY_CRONTAB_ROOT
		ONEKEY_FLEXGET1=`cat /var/spool/cron/crontabs/root | grep '/usr/local/bin/flexget > /root/flexget.log 2>&1'`
		ONEKEY_FLEXGET2=`cat /var/spool/cron/crontabs/root | grep 'rm -rf /root/.flexget/.config-lock'`
		ONEKEY_FLEXGET3=`cat /var/spool/cron/crontabs/root | grep 'rm -rf /home/hapshon/transmission/rss/*'`
		if [ -n "$ONEKEY_FLEXGET1" ]; then
			echo "${CYELLOW}Flexget定时运行已经设置  跳过$CEND"
		else
			echo "*/5 * * * * /usr/local/bin/flexget execute --cron >> /root/flexget.log 2>&1" >> $ONEKEY_CRONTAB_ROOT
		fi
		if [ -n "$ONEKEY_FLEXGET2" ]; then
			echo "${CYELLOW}Flexget防止自动锁设置已经配置   跳过$CEND"
		else
			echo "*/1 * * * * rm -rf /root/.flexget/.config-lock" >> $ONEKEY_CRONTAB_ROOT
		fi
		if [ -n "$ONEKEY_FLEXGET3" ]; then
			echo "${CYELLOW}定时清空Flexget RSS种子缓存已经设置   跳过$CEND"
		else
			echo "*/20 * * * * rm -rf /home/hapshon/transmission/rss/*" >> $ONEKEY_CRONTAB_ROOT
		fi
		crontab $ONEKEY_CRONTAB_ROOT
		crontab -l&&printf "\033c"
}
config_transmission() {
		mkdir -p $ONEKEY_FLEXGET_DIRECTORY
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/downloads
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/incomplete
		mkdir -p $ONEKEY_NEWUSER_DIRECTORY/trrss
		chmod 777 -R $ONEKEY_NEWUSER_DIRECTORY/*
		$ONEKET_TR_START stop
		echo > $ONEKEY_TR_CONFIG
}
install_rapidleech() {
		$ONEKEY_ONLINE_INSTALL -y apache2
		$ONEKEY_ONLINE_INSTALL -y php5 php5-gd php5-cli
		sed -i 's@var/www@home/Rapidleech@' /etc/apache2/sites-available/default
		sed -i 's@var/www@home/Rapidleech@' /etc/apache2/sites-available/default-ssl
		/etc/init.d/apache2 restart
		wget -q -O /home/Rapidleech.tar.gz $ONEKEY_DOWNLOAD_LINK/Rapidleech23_v43_SVN409.tar.gz
		cd /home
		tar xvf Rapidleech.tar.gz
		rm -rf Rapidleech.tar.gz
		chmod 777 Rapidleech/configs
		chmod 777 Rapidleech/files
		chmod 777 Rapidleech/configs/files.lst && cd
		getIpAddress
		printf "\033c" && cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   Rapidleech 安装配置结束$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Rapidleech 地址  :$CGREEN http://$OUR_IP_ADDRESS$CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}
trflexget_config() {
		cd $ONEKEY_FLEXGET_DIRECTORY/
		wget -q -O $ONEKEY_FLEXGET_DIRECTORY/config.yml $ONEKEY_DOWNLOAD_LINK/trrss.yml && printf "\033c"
		if [ "$trname" = "" -a "$trpasswd" = "" ]; then
			echo "${CQUESTION}请输入你的Transmission登陆帐号:$CEND"
			read trname
			echo "${CQUESTION}请输入你的Transmission登陆密码:$CEND"
			read trpasswd2
		else
			trpasswd2=$(cat /tmp/userpassword)
			trname=$(cat /tmp/username)
		fi
		printf "\033c"
		echo "${CYELLOW}                        请输入你的RSS地址, 如果不想配置RSS请直接按 \"ENTER\" ，脚本会自行跳过$CEND"
		echo "${CQUESTION}请输入你的CHD RSS地址 :$CEND"
		read chdrss1
		echo "${CQUESTION}请输入你的CHD下载框地址 :$CEND"
		read chdrss2
		echo "${CQUESTION}请输入你的TTG RSS地址 :$CEND"
		read ttgrss1
		echo "${CQUESTION}请输入你的TTG小货车地址 :$CEND"
		read ttgrss2
		if [ $blockHDWing = "n" ]; then
			echo "${CQUESTION}请输入你的HDWing RSS地址 :$CEND"
			read HDWingrss1
			echo "${CQUESTION}请输入你的HDWing下载框地址 :$CEND"
			read HDWingrss2
		else
			echo "${CWARNING}#############由于你选择了屏蔽HDWing网站，所以不做HDWing RSS配置#############$CEND"
		fi
		echo ""
		if [ "$chdrss1" != "" ]; then
			chdrss1=`echo "$chdrss1" | sed 's@\&@\\\&@g'`
			sed -i 3,3s@rss:.*@"rss: $chdrss1"@ config.yml
		else
			sed -i '2,21s/.*//' config.yml
		fi
		if [ "$chdrss2" != "" ]; then
			chdrss2=`echo "$chdrss2" | sed 's@\&@\\\&@g'`
			sed -i 23,23s@rss:.*@"rss: $chdrss2"@ config.yml
		else
			sed -i '22,33s/.*//' config.yml
		fi
		if [ "$ttgrss1" != "" ]; then
			ttgrss1=`echo "$ttgrss1" | sed 's@\&@\\\&@g'`
			sed -i 35,35s@rss:.*@"rss: $ttgrss1"@ config.yml
		else
			sed -i '34,53s/.*//' config.yml
		fi
		if [ "$ttgrss2" != "" ]; then
			ttgrss2=`echo "$ttgrss2" | sed 's@\&@\\\&@g'`
			sed -i 55,55s@rss:.*@"rss: $ttgrss2"@ config.yml
		else
			sed -i '54,65s/.*//' config.yml
		fi
		if [ $blockHDWing = "n" ]; then
			if [ "$HDWingrss1" != "" ]; then
				HDWingrss1=`echo "$HDWingrss1" | sed 's@\&@\\\&@g'`
				sed -i 67,67s@rss:.*@"rss: $HDWingrss1"@ config.yml
			else
				sed -i '66,86s/.*//' config.yml
			fi
			if [ "$HDWingrss2" != "" ]; then
				HDWingrss2=`echo "$HDWingrss2" | sed 's@\&@\\\&@g'`
				sed -i 88,88s@rss:.*@"rss: $HDWingrss2"@ config.yml
			else
				sed -i '87,98s/.*//' config.yml
			fi
		else
			sed -i '66,98s/.*//' config.yml
		fi
		printf "\033c"
		sed -i s@hapshon/transmission@"$trname"@ config.yml
		sed -i s@trpasswd@"$trpasswd2"@g config.yml
		sed -i '/^$/d' config.yml
		dos2unix $ONEKEY_FLEXGET_DIRECTORY/config.yml
		sed -i 's/^M//g' config.yml
		printf "\033c"
		printf "\033c" && cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   Tranmission RSS 一键配置结束 $CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Flexget 配置文件路径 $ONEKEY_NEWUSER_DIRECTORY/flexget/config.yml $CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}
deflexget_config() {
		mkdir -p /root/.flexget && cd $ONEKEY_FLEXGET_DIRECTORY/
		wget -q -O $ONEKEY_FLEXGET_DIRECTORY/config.yml $ONEKEY_DOWNLOAD_LINK/config.yml
		printf "\033c"
		echo "${CYELLOW}		请输入你的RSS地址, 如果不想配置RSS请直接按 \"ENTER\" ，脚本会自行跳过$CEND"
		if [ $blockHDWing = "n" ]; then
			echo "${CQUESTION}请输入你的HDWing RSS地址 :$CEND"
			read HDWingrss1
			echo "${CQUESTION}请输入你的HDWing下载框地址 :$CEND"
			read HDWingrss2
		else
			echo "${CWARNING}#############由于你选择了屏蔽HDWing网站，所以不做HDWing RSS配置#############$CEND"
		fi
		echo ""
		if [ $blockHDWing = "n" ]; then
			if [ "$HDWingrss1" != "" ]; then
				HDWingrss1=`echo "$HDWingrss1" | sed 's@\&@\\\&@g'`
				sed -i 3,3s@rss:.*@"rss: $HDWingrss1"@ config.yml
			else
				sed -i '2,22s/.*//' config.yml
			fi
			if [ "$HDWingrss2" != "" ]; then
				HDWingrss2=`echo "$HDWingrss2" | sed 's@\&@\\\&@g'`
				sed -i 24,24s@rss:.*@"rss: $HDWingrss2"@ config.yml
			else
				sed -i '23,34s/.*//' config.yml
			fi
			else
				sed -i '2,34s/.*//' config.yml
			fi
		printf "\033c"
		sed -i '/^$/d' config.yml
		dos2unix $ONEKEY_FLEXGET_DIRECTORY/config.yml
		WAIT_TIME
		ONEKEY_DELUGE_PASS=`awk -F ':' '{print $2}' /root/.config/deluge/auth`
		ONEKEY_DELUGE_USERNAME=`awk -F ':' '{print $1}' /root/.config/deluge/auth`
		sed -i s/"pass: *"/"pass: $ONEKEY_DELUGE_PASS"/g config.yml
		printf "\033c" && cat << EOF
		${CQUESTION}==================================================================$CEND
		${CQUESTION}=                   Deluge RSS 一键配置结束 $CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= Flexget 配置文件路径 $ONEKEY_NEWUSER_DIRECTORY/flexget/config.yml $CEND
		${CQUESTION}==================================================================$CEND
		${CQUESTION}= 感谢使用 SEEDBOX-军团 一键安装脚本$CEND
		${CQUESTION}= SEEDBOX-军团 网址 $CGREEN$ONEKEY_WEB_LINK$CEND
		${CQUESTION}==================================================================$CEND
EOF
}

#===========================================================================================================
SOURCES_CHANGE=`ls /etc/apt/ | grep 2014`
if [ -n "$SOURCES_CHANGE" ]; then
	printf "\033c" && echo "${CYELLOW}系统源列表无需更改，程序继续执行$CEND" && sleep 2
	for i in {dos2unix,vim,sl,htop,linuxlogo,curl,dialog,wget}
	do 
		check=`dpkg -l | grep "ii  $i" | awk 'NR<2' | awk '{print$3}'`
		if [ -z "$check" ]; then
			apt-get install $i
		fi
	done
elif [ "$ONEKEY_OVH_CHECK1" = "kimsufi" ] || [ "$ONEKEY_OVH_CHECK1" = "ovh" ] || [ -n "$ONEKEY_OVH_CHECK2" ] || [ -n "$ONEKEY_OVH_CHECK3" ]; then
	printf "\033c" && echo "${CYELLOW}系统源列表为OVH源，系统源列表无需更改，程序继续执行$CEND" && sleep 2
	apt-get update && apt-get -f install -y
	for i in dos2unix vim sl htop linuxlogo curl dialog wget; do $ONEKEY_ONLINE_INSTALL $i -y;done
else
	if [ -n $ONEKEY_YUAN ]; then
		printf "\033c" && echo "${CYELLOW}系统源列表已经修改成官方源，程序继续执行$CEND" && sleep 2
		#mv /etc/apt/sources.list /etc/apt/sources.list.$(date +%F_%T).backup
		echo "=请选择==========================="
		echo "=1.使用archive.ubuntu.com官方源  ="
		echo "=2.使用国内阿里云源              ="
		echo "=3.不更改源                      ="
		echo "=默认官方源======================="
		echo "=================================="
		sourcechoose="1"
		read -p "请输入编号：" sourcechoose
		
        case "$sourcechoose" in
	    1)
		echo "您选择更改源为官方源"
		sourcechoose="1"
		mv /etc/apt/sources.list /etc/apt/sources.list.$(date +%F_%T).backup
		#官方源
		cat > /etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
EOF
		;;
		2)
		echo "您选择使用阿里云源"
		sourcechoose="2"
		mv /etc/apt/sources.list /etc/apt/sources.list.$(date +%F_%T).backup
		cat > /etc/apt/sources.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
EOF
		;;
		3)
		echo "您选择不更改源"
		sourcechoose="3"
		;;
		*)
		echo "将会更改为默认源"
		cat > /etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
EOF
		esac
		
#		cat > /etc/apt/sources.list << EOF
#deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
#deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
#deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
#deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
#deb http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-security main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-updates main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-proposed main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ $ONEKEY_YUAN-backports main restricted universe multiverse
#EOF
		
		
		apt-get update && apt-get -f install -y
		for i in dos2unix vim sl htop linuxlogo curl dialog wget; do $ONEKEY_ONLINE_INSTALL $i -y;done
		#cp /etc/apt/sources.list /etc/apt/sources.list.$(date +%F_%T).backup && ONEKEY_ONLINE_INSTALL="aptitude install" && apt-get update && $ONEKEY_ONLINE_INSTALL dos2unix vim sl htop linuxlogo curl dialog wget -y && apt-get -f install -y
	else
		printf "\033c"
		echo "系统版本不能识别，为了系统的安全稳定，退出系统运行"
		exit
	fi
fi
GONG_GA0 && printf "\033c"
if [ -n "$ONEKEY_UBUNTU_VERSION" ] || [ -n "$ONEKEY_DEBIAN_VERSION" ]; then
	LOGO_CHECK=`cat /etc/update-motd.d/00-header | grep -o SEEDBOX`
	[ -z "$LOGO_CHECK" ] && sed -i 's/\\n/for SEEDBOX军团一键脚本\\n/g' /etc/update-motd.d/00-header
	LOGOFILE="/etc/ubuntul"
	if [ ! -f "$LOGOFILE" ]; then
		echo "$ONEKEY_LOGO" > /etc/ubuntul
		#sed -i '$ i \\ncat /etc/ubuntul\n' /etc/update-motd.d/00-header
		sed -i '$ i \\necho -e "\\033[31m $(cat /etc/ubuntul) \\033[0m"\n' /etc/update-motd.d/00-header
	fi
	disk=`df | grep '/dev/' | grep '/' | awk '{print $2,$1}' | sort -rn | awk 'NR<2' | awk -F ' ' '{print $2}'`
	[ -n $disk ] && tune2fs -m .3 $disk
	if [ "$ONEKEY_OVH_CHECK1" = "kimsufi" ] || [ "$ONEKEY_OVH_CHECK1" = "ovh" ] || [ -n "$ONEKEY_OVH_CHECK2" ] || [ -n "$ONEKEY_OVH_CHECK3" ]; then
		apt-get autoremove acpid bind9 at -y
		rm -rf /etc/localtime
		ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
		apt-get install ntpdate fortune-zh -y
		ntpdate fr.pool.ntp.org
		printf "\033c"
	fi
	if [ -n "$ONEKEY_OPENDIR" ]; then
		printf "\033c" && echo "${CQUESTION}文件打开数已经破解,若没有生效请重启系统一次$CEND"&&sleep 1&&printf "\033c"
	else
		sed -i '/# End of file/d' /etc/security/limits.conf
		cat >> /etc/security/limits.conf << EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
		echo "# End of file" >> /etc/security/limits.conf
		cat >> /etc/sysctl.conf << EOF
fs.file-max=65535
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30 
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_orphans = 16384
EOF
		echo "session required pam_limits.so" >> /etc/pam.d/common-session
		echo "ulimit -SHn 65535" >> /etc/profile
		$(which sysctl) -p
		/sbin/sysctl -p && printf "\033c"
		seq 3 | xargs -i `source /etc/profile`
	fi
#================================================================
	#rm -rf /root/.vimrc && wget -q -O /root/vim.tar $ONEKEY_DOWNLOAD_LINK/vim.tar
	#cd /root/ #&& tar -xf vim.tar && rm -rf vim.tar
	wget -cq4 http://sh.laiboke.com/box/vimrc -O /root/.vimrc
	wget -cq4 http://sh.laiboke.com/box/screenrc -O /root/.screenrc
	printf "\033c"
	cat << EOF
${CGREEN}$ONEKEY_LOGO$CEND
EOF
	sleep 3 && printf "\033c"
	if [ -n "$ONEKEY_UBUNTU_VERSION" ]; then
		linuxlogo -L ubuntu
	elif [ -n "$ONEKEY_DEBIAN_VERSION" ]; then
		linuxlogo -L debian
	else
		linuxlogo -L banner
	fi
	sleep 3
	men
else
	sleep 2 && printf "\033c"
	echo "${CQUESTION}对不起!!!!! 你的服务器不是$CEND ${CGREEN}Ubuntu 或者 Debian.........................$CEND"
	echo "Bye Bye"
	echo "${CQUESTION}Shell 脚本运行结束时间: $CGREEN$ONEKEY_TIME$CEND"
	exit
fi
