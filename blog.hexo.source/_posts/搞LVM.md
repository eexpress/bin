---
title: 搞LVM
date: 2017-04-10 11:43:56
tags:
- lvm
---
1. 删除老的swap分区。

		▶ sudo fdisk /dev/sda
		命令(输入 m 获取帮助)：p
		设备       启动      起点      末尾      扇区   大小 Id 类型
		/dev/sda1  *         2048 525504511 525502464 250.6G 83 Linux
		<--------- 中间是空白区域
		/dev/sda2       945184768 976773119  31588352  15.1G 82 Linux 交换 / Solaris
		命令(输入 m 获取帮助)：d
		分区号 (1,2, default 2): 2
		分区 2 已删除。
		命令(输入 m 获取帮助)：w
		重新读取分区表失败。: Device or resource busy
		内核仍在使用旧分区表。新分区表将在下次重启或运行 partprobe(8) 或 kpartx(8) 后生效。
		▶ sudo partprobe /dev/sda

1. 格式化空白区域，产生sda2。

		命令(输入 m 获取帮助)：F
			 起点      末尾      扇区   大小
		525504512 976773167 451268656 215.2G
		命令(输入 m 获取帮助)：n
		分区类型
		   p   主分区 (1个主分区，0个扩展分区，3空闲)
		   e   扩展分区 (逻辑分区容器)
		选择 (默认 p)：p
		分区号 (2-4, default 2): 2
		第一个扇区 (525504512-976773167, default 525504512):
		上个扇区，+sectors 或 +size{K,M,G,T,P} (525504512-976773167, default 976773167):
		创建了一个新分区 2，类型为“Linux”，大小为 215.2 GiB。
		命令(输入 m 获取帮助)：p
		设备       启动      起点      末尾      扇区   大小 Id 类型
		/dev/sda1  *         2048 525504511 525502464 250.6G 83 Linux
		/dev/sda2       525504512 976773167 451268656 215.2G 83 Linux

1. 产生PV，添加到VG。

		▶ sudo pvcreate /dev/sda2
		  Physical volume "/dev/sda2" successfully created.
		▶ sudo vgs
		  VG     #PV #LV #SN Attr   VSize  VFree
		  fedora   1   2   0 wz--n- 28.62g    0
		▶ sudo vgextend fedora /dev/sda2
		  Volume group "fedora" successfully extended
		▶ sudo vgs
		  VG     #PV #LV #SN Attr   VSize   VFree
		  fedora   2   2   0 wz--n- 243.80g 215.18g

1. 下次root不足的时候，再添加容量。

		▶ sudo pvs
		  PV         VG     Fmt  Attr PSize   PFree  
		  /dev/sda2  fedora lvm2 a--  215.18g 215.18g
		  /dev/sdb3  fedora lvm2 a--   28.62g      0 
		▶ sudo vgs
		  VG     #PV #LV #SN Attr   VSize   VFree  
		  fedora   2   2   0 wz--n- 243.80g 215.18g
		▶ sudo lvs
		  LV   VG     Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
		  root fedora -wi-ao---- 25.63g
		  swap fedora -wi-ao----  2.98g
	

		---> 	lvextend -r -L100G /dev/fedora/root

