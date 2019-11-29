#!/bin/bash
export PATH=/usr/local/jdk1.8.0_171/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin
while :
do
# 检查根分区
ROOT=$(df -Th|head -n 3|tail -n -2|awk -F"[ ]+" '{print $1,$6,$7}'|tr -t "\n"  " ")
USE=$(echo $ROOT | awk '{print $2}'|cut -d% -f1)
if [ $USE -ge 45 ];then
	echo "磁盘分区：$ROOT 使用超过阈值：80" &>> /tmp/disk.log
else
	echo "磁盘分区：$ROOT 正常" &>> /tmp/disk.log

fi
sleep 2
# 检查boot分区
BOOT=$(df -Th | tail -n 1|awk '{print $1,$6,$7}')
BOOT_USE=$(echo $BOOT|awk '{print $2}'|cut -d% -f1)

if [ $BOOT_USE -ge 45 ];then
	echo "磁盘分区：$BOOT 使用超过阈值：80" &>> /tmp/disk.log
else
	echo "磁盘分区：$BOOT 使用正常" &>> /tmp/disk.log
fi
sleep 2
done
