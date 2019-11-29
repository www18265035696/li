#!/bin/bash

export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
. /etc/init.d/functions
lvs() {
rpm -qa |grep ipvsadm &> /dev/null

 if [[ $? -ne 0 ]];then
	yum -y install ipvsadm
fi
# 获取用户键盘输入注意：请以字符串方式输入
read -p "pelase input your vip:" vip
read -p "pelase input your ip_address:" ip
# 定义用户的输入为：数组
VIP=(`echo $vip`)
echo ${VIP[@]} > vip.txt
ip=(`echo $ip`)
# 通过 for 循环遍历 数组
for ((i=0;i < $(echo "${#VIP[@]}");i++))
do

	ifconfig eth0:${i} ${VIP[$i]} broadcast ${VIP[$i]} netmask 255.255.255.255 up
	/sbin/ipvsadm -C
	vp=$(echo ${VIP[$i]})
	/sbin/ipvsadm -A -t ${vp}:80 -s rr
	for ((a=0;a < $(echo "${#ip[@]}");a++))
	do
	        rip=$(echo ${ip[$a]})
		ipvsadm -a -t ${vp}:80 -r ${rip} -g
	done
	
done
}

rs() {
num=0
for i in $(cat /root/shell/vip.txt);do
((num++))
ifconfig lo:${num} ${i} broadcast ${i} netmask 255.255.255.255 up

done
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore   
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
echo "###################################################"
echo "rs_configure sessuec!!!!"
echo "###################################################"
}

list=(
lvs
rs
quit
)
PS3="Pelase input your option number:"
select i in ${list[@]}
do 
    case $i in
    lvs)
	lvs
    ;;
    rs)
	rs
    ;;
    quit)
	exit 0
    ;;

    *)
	echo "sh lvs.sh "
    ;;

    esac

done



