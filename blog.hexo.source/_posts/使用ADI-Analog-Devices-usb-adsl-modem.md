title: 使用ADI(Analog Devices) usb adsl modem
date: 2005-12-23 18:12:53
tags:
---

一个闲置的同维699CHA adsl usb modem，代替699B用用。

$ lsusb
Bus 005 Device 001: ID 0000:0000
Bus 004 Device 003: ID 1110:9021 Analog Devices Canada, Ltd (Allied Telesyn)
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000


找了一些介绍。还是比较难找到的。绕了好久。
AD6485 - Eagle-II USB/Ethernet 
[http://www.analog.com/en/prod/0,2877,AD6485,00.html](http://www.analog.com/en/prod/0,2877,AD6485,00.html) 
[http://dev.eagle-usb.org/wakka.php?wiki=EagleUsb230](http://dev.eagle-usb.org/wakka.php?wiki=EagleUsb230) 
[http://baud123.free.fr/eagle-usb/eagle-usb-2.3/eagle-usb-2.3.2.tar.bz2](http://baud123.free.fr/eagle-usb/eagle-usb-2.3/eagle-usb-2.3.2.tar.bz2) 
编译了半天，不确定是否正确。因为和单独下的一个pdf说明完全不同。哎，原来在ubuntu源里面有个1.9.9的。

由于没有说明，自己一个一个试，最后整理了一下包你们的文件说明。

> /etc/eagle-usb/**eagle-usb.conf** #主要设备配置，针对应该的VPI，VCI等，都在里面。可以手工修改。
> /etc/ppp/chap-secrets #保留用户名和密码。 
> /etc/ppp/peers/adsl #联网配置设置。
> /etc/ppp/peers/mire #类似配置，法国电信搞的什么东西，特殊的协议？
> /usr/sbin/fctStartAdsl #内置的启动掉用，startadsl就是掉用这个。
> /usr/sbin/fctStopAdsl #
> /usr/sbin/startmire #法国电信搞的烂协议。
> /usr/sbin/startadsl #类似是主执行文件，就是在这个以前modem并没有起来。
> /usr/sbin/stopadsl #
> /usr/sbin/eaglediag #调试，检查所有配置状态，需要全部显示OK。
> /usr/sbin/**eagleconfig** #主要的配置和启动。就是只能设置固定的ISP和VPI VCI，还是要手工修改/etc/eagle-usb/eagle-usb.conf 
> /usr/sbin/**eaglectrl** #搞了半天才找出来的主要启动modem的文件。
> /usr/sbin/eaglestat #查看联网状态 
> /usr/sbin/pppoa 
> /etc/eagle-usb/scripts/**eu_config_bash** #就是那些选择ISP的。已经归类了。当然没有适合中国的，还不能选手动。气死。最后修改了一个自己需要的。 
> 增加：
> <span style="color: red">"xCN01" ) VPI="00" ; VCI="20" ; ENC="03" ; COUNTRY="Chinese" ; ISP_NAME="163" ;; 
> for ISP_TMP in AT01 BE01 BR01 BR02 BR03 BR04 BG01 BG02 DK01 DE01 ES01 ES02 ES03 ES04 FI01 FR01 FR02 FR03 FR04 FR05 FR06 FR07 GR01 HU01 IE01 IT01 IT02 IT03 NL01 PL01 PT01 SE01 CH01 CH02 <span style="color: red">CN01 UK01 ; do

**配置步骤：**
1。sudo eagleconfig 
系统在usb插入时，好像出了一个sit0（ifconfig可以看到）。但是很难清晰的追到。不知原因。由此配置程序虚拟出一个eth0，可以一次性把modem启动及联网全部完成。但重新配置就不执行这些步骤了。搞了好久才清楚。原来如果要一次性执行启动mod等，必须修改成不同的配置，再改回来。
2。然后pppoeconf eth0。才出一个ppp0。还有修改/etc/networks/interface，把eth0加上去。
软件带的startadsl都不要用。但是开机不能自动启动。
软件自己建了一个服务，进程守护程序S99eagle-usb -&gt; ../init.d/eagle-usb。其实就是执行了sudo fctStartAdsl，但我执行了，没反应。还只能ctrl-c。倒是关机时，它知道停止服务。

**启动步骤：**
eaglectrl -w 
sudo pon dsl-provider 

看了下，eagle-usb.org的都是法语。英语的有一点。有现象和我一样，竟然说要编译模块。有个家伙还说他就喜欢&lt;eaglectrl -w&gt;，再&lt;startadsl&gt;。气死。摘录了一点FAQ。
37\. The module does not LOAD at boot 

CHECK the module is installed in the following directory: 
/lib/modules/$KVERS/misc 

Check hotplug is installed and that the kernel is configured to use it. 
Check that the module dependencies are up to date. CHECK the file 
/lib/modules/KVERS/modules.usbmap to see ig it contains references to 
the eagle-usb.(o|ko) module. 

CHECK you have a recent version of modutils. 

38\. The module is loaded at boot, bug hotplug do not load 
the firmware or the DSP code 

Hotplug should LOAD the DSP code thanks to the script 
/etc/hotplug/usb/eagle-usb 

It is called whenever the modem declares itself on the USB bus 
with the USB identifiers that are specified in the file 
/lib/modules/$KVERS/modules.usbmap, 
just after the module was loaded. 

CHECK these files are correct, and that have execute permission.
测试执行了一下。
exp@exp-ubuntu:~$ ll /etc/hotplug/usb/eagle-usb 
ls: /etc/hotplug/usb/eagle-usb: 没有那个文件或目录 
exp@exp-ubuntu:~$ ll /lib/modules/$KVERS/modules.usbmap 
ls: /lib/modules//modules.usbmap: 没有那个文件或目录 

$ ll /lib/modules/2.6.10-5-686/modules.usbmap 
-rw-r--r-- 1 root root 263544 2005-11-06 02:21 /lib/modules/2.6.10-5-686/modules.usbmap 

$ whereis eagle-usb 
eagle-usb: /etc/eagle-usb /usr/lib/eagle-usb
_________________

----------------------------------------------------
<span style="font-size: 100%">**dapper** new
----------------------------------------------------
> ai eagle-usb-utils
> 自动启动了配置。
> /etc/eagle-usb/* 
> /etc/hotplug/usb/eagle-usb 
> /etc/init.d/eagle-usb
> 
> /usr/sbin/eaglediag
> /usr/sbin/eagleconfig
> 
> /usr/sbin/eagleconfig_front.bash ISP列表
> "xCN12" )  VPI="0" ; VCI="20" ; ENC="3" ; COUNTRY="China" ; ISP_NAME="China Telecom Hangzhou" ; CMVep=WO ; CMVei=WO ;;
> 这个配置适合湖南电信
> 
> /usr/sbin/fctStartAdsl
> /usr/sbin/fctStopAdsl
> /usr/sbin/startadsl
> /usr/sbin/stopadsl
> /usr/sbin/eagletestconnec
> /usr/sbin/eaglectrl
> /usr/sbin/eaglestat
> /usr/sbin/pppoa
> /usr/share/eagle-usb/lang/*