#!/bin/bash
export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

#a=$(top -b -n 1 | grep Cpu | awk '{print $5}' | cut -d"." -f1)

#[ $a -le 20 ] && echo "警告" || echo "正常"
while :
do
kx=$(vmstat -n 2 3|tail -n 1 |awk -F"[ ]+" '{print $15}')
sleep 2
top=20
num=$(echo "$kx<=$top" |bc)

#[ $num -eq 1 ] && echo "cpu 空闲率:${kx}%" && echo "$(date):cpu 使用率过高"|| echo "$(date):cpu 使用率正常 "   &>> /tmp/cpu.log
if [ $num -eq 1 ];then
	echo "$(date):CPU 使用过高，空闲率是：${kx}%" &>> /tmp/cpu.log
else
	echo "$(date):CPU 使用正常，空闲率是：${kx}%" &>> /tmp/cpu.log
fi
sleep 2
done
