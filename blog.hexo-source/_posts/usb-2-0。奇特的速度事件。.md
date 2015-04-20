title: usb 2.0。奇特的速度事件。
date: 2006-07-27 05:07:05
tags:
---

增强主机控制器接口（Enhanced Host Controller Interface，EHCI）
理论传输速度：480 Mbps
实际不如火线（理论传输速度：400 Mbps）。
火线：IEEE（Institute of Electrical and Electronics Engineers）1394标准

USB1.1标准速度：12Mbps

**$ dmesg | tail -n 20**
[4295498.850000] usb 6-3: USB disconnect, address 2
[4295557.556000] usb 6-3: new **<span style="color: red">high speed** USB device using **<span style="color: red">ehci_hcd** and address 3[4295557.839000] scsi1 : SCSI emulation for USB Mass Storage devices
[4295557.839000] usb-storage: device found at 3
[4295557.839000] usb-storage: waiting for device to settle before scanning
[4295562.840000]   Vendor: FUJITSU   Model: MHT2040AT         Rev: 0022
[4295562.840000]   Type:   Direct-Access                      ANSI SCSI revision: 00
[4295562.842000] SCSI device sdb: 78140161 512-byte hdwr sectors (40008 MB)
[4295562.842000] sdb: assuming drive cache: write through
[4295562.844000] SCSI device sdb: 78140161 512-byte hdwr sectors (40008 MB)
[4295562.844000] sdb: assuming drive cache: write through
[4295562.844000]  sdb: sdb1 sdb2
[4295563.194000] sd 1:0:0:0: Attached scsi disk sdb
[4295563.194000] sd 1:0:0:0: Attached scsi generic sg0 type 0
[4295563.195000] usb-storage: device scan complete
[4295563.438000] sdb: Current: sense key: No Sense
[4295563.438000]     Additional sense: No additional sense information
[4295566.240000] kjournald starting.  Commit interval 5 seconds
[4295566.240000] EXT3 FS on sdb1, internal journal
[4295566.240000] EXT3-fs: mounted filesystem with ordered data mode.

我的usb 2.0硬盘却只有663KB/s。而在windows下面测试，达到13.353710938MB/s。

$ **lspci -v | grep "USB 2.0"**
0000:00:0b.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: ALi Corporation USB 2.0 Controller
$ **lsusb**
Bus 006 Device 003: ID 13e0:2507
Bus 006 Device 001: ID 0000:0000
Bus 005 Device 001: ID 0000:0000
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
$ **lsmod|grep usb**
usb_storage            79488  2
scsi_mod              145960  5 sg,sd_mod,sr_mod,sbp2,usb_storage
usbcore               137700  4 usb_storage,ehci_hcd,ohci_hcd
$ **sudo lsusb -v|head -n 17**
Bus 006 Device 003: ID 13e0:2507
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x13e0
  idProduct          0x2507
  bcdDevice            0.01
  iManufacturer           1 ValueDisk
  iProduct                2 USB 2.0 Disk-On-The-Go
  iSerial                 3 200408164209
  bNumConfigurations      1
![](http://forum.ubuntu.org.cn/weblogs/upload/6/119092998344c82a2ad469b.gif)
![](http://forum.ubuntu.org.cn/weblogs/upload/6/45321087844c82a71c5c88.jpg)
$ **awk -F[ "BEGIN{RS = ""} /Disk-On-The-Go/" /proc/bus/usb/devices**
T:  Bus=06 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  3 Spd=**480** MxCh= 0
D:  Ver= **2.00** Cls=00(&gt;ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=13e0 ProdID=2507 Rev= 0.01
S:  Manufacturer=ValueDisk
S:  Product=USB 2.0 **Disk-On-The-Go**
S:  SerialNumber=200408164209
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

-----------新的测试数据---------- 
$ date;cp /home/exp/install/游戏/NorthlandDemo.run /media/USB-FAT/;date 
2006年 07月 28日 星期五 14:58:26 CST 
2006年 07月 28日 星期五 14:59:03 CST 
$ date;cp /home/exp/install/游戏/NorthlandDemo.run /media/USB-EXT3/;date 
2006年 07月 28日 星期五 15:02:52 CST 
2006年 07月 28日 星期五 15:04:50 CST 
$ ll /home/exp/install/游戏/NorthlandDemo.run 
-rw-r--r-- 1 exp exp 80150706 2006-03-27 10:06 /home/exp/install/游戏/NorthlandDemo.run 

FAT分区：2`166`235.297297297 B/s 
EXT分区：679`243.271186441 B/s 
奇怪了。日志文件系统慢这样多？