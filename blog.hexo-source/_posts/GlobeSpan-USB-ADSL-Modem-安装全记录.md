title: GlobeSpan USB ADSL Modem 安装全记录
date: 2005-10-06 05:10:13
tags:
---

GlobeSpan USB ADSL Modem 安装全记录
Tag： GlobeSpan    USB    ADSL    Modem                                           

一直使用老的USB ADSL MODEM。芯片型号是GlobeSpan。在linux下配置比较麻烦一点。需要自己找驱动。以下是在ubuntu(Debian)系统下安装的全过程。

在linux下，原始设备可能是/dev/ptysd。这点是我猜的。因为没有找到关于这方面的说明书籍。

首先，可以看一下USB设备的情况。这样可以预先确认设备的芯片型号。最好记住ID 0915:0002设备号。也可以到系统的设备管理程序中看一下。当然，驱动中也带了probe的程序。可以查看到设备号。

$ lsusb
Bus 005 Device 001: ID 0000:0000
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 010: ID 0915:0002 GlobeSpan, Inc.
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000

下面就是找驱动。找到的驱动下载地址 [http://eciadsl.flashtux.org/](http://eciadsl.flashtux.org/) 。需要下载驱动包 eciadsl-usermode_0.10-beta1_i386.deb（稳定版本）。
如果向我一样喜欢最新的，就下0.11测试版本（需要升级libc6，libasound等库，如需要libc6_2.3.2.ds1-22_i386.deb支持，ubuntu的hoary版本原配的libc6版本低了）。但是，到时候需要打乱系统的原有依赖关系，升级几个库到高版本。搞得安装系统本身的其他软件时，又要冒险在线卸载高版本，完成安装后，再升级回来。其中还不能断线的哦。

$ dpkg -i eciadsl-usermode_0.10-beta1_i386.deb
使用deb包安装eciadsl驱动是很简单的，没有任何出错提示就完成了。eciadsl.flashtux.org的rpm版本，以前我也在Redflag下安装过，不过是使用0.9和0.10的杂交版本配置成功的。远没有ubuntu下软件管理方式好。

安装驱动包后，使用eciadsl-config-tk图形界面配置产生/etc/eciadsl/eciadsl.conf。这里就需要填写设备的ID号。选择Globespan的型号，缺省的ID号正好可以。选择封装最重要。
因为已经是稳定版本，其他的eciadsl-xxxx程序可以不要运行。（probe是测试设备的，还有chek-hdlc等）。
接下来就是选择设备的同步文件。在0.9版本时，要手工一个一个测试同步bin文件，有50几个（每次换文件还要断电）。现在的版本可以用eciadsl-probe-synch一次自动测试哪个bin符合你的modem。
我的bin是synch05.bin。
以下是最重要的配置文件。

$ cat /etc/eciadsl/eciadsl.conf
VID1=0915 ＃ID号2组
PID1=0001
VID2=0915
PID2=0002
MODE=LLC_SNAP_RFC1483_BRIDGED_ETH_NO_FCS ＃封装
VCI=32 ＃本地的2个DSL设置，向ISP要。
VPI=0
FIRMWARE=/etc/eciadsl/firmware00.bin
SYNCH=/etc/eciadsl/synch05.bin ＃千辛万苦出来的同步文件
PPPD_USER=CSD1073424
PPPD_PASSWD=
USE_DHCP=yes
USE_STATICIP=no
STATICIP=
GATEWAY=
MODEM=Cypress Globespan G7000
PROVIDER=Other
DNS1=202.103.96.112
DNS2=202.103.96.88

下来就可以驱动modem了。

$ eciadsl-start 
[EciAdsl 1/5] Setting up USB support... 

Preliminary USB device filesystem is OK 

[EciAdsl 2/5] Uploading firmware... 

GlobeSpan GS7070 USB ADSL WAN Modem compatible modem found (in 2424ms) 
eciadsl-firmware: success 
firmware loaded successfully 

[EciAdsl 3/5] Synchronization... ＃0.10版本有一段数据同步提示。这段是0.11版本的。

OK eciadsl-synch: success 
Synchronization successful 

＃＃＃这是0.10版本提示 

Progress indicator is 01 No Signal ! 
Progress indicator is a0 No Signal ! 
Progress indicator is a1 Training... 
Progress indicator is a1 Training... 
Progress indicator is 43 Training... 
Progress indicator is a4 Training... 
Progress indicator is a4 Training... 
Progress indicator is 74 Training... 
Progress indicator is a6 Training... 
Progress indicator is 77 Training... 
Progress indicator is 75 Training... 
Progress indicator is aa Training... 
Progress indicator is 72 Training... 
Progress indicator is ad Training... 
eciadsl-synch: success 
Synchronization successful 

[EciAdsl 4/5] Connecting to provider... 

Connection successful 

[EciAdsl 5/5] Setting up route table... 

Waiting for tap0... ＃映射出tap0设备

只要是提示出了tap0，就说明虚拟出了一个tap0网络设备。看一下网络设备清单，有数据在跑。

$ ifconfig 
lo Link encap:Local Loopback
inet addr:127.0.0.1 Mask:255.0.0.0
inet6 addr: ::1/128 Scope:Host
UP LOOPBACK RUNNING MTU:16436 Metric:1
RX packets:166425 errors:0 dropped:0 overruns:0 frame:0
TX packets:166425 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:0
RX bytes:64796 (63.2 KiB) TX bytes:64796 (63.2 KiB) 

tap0 Link encap:Ethernet HWaddr 00:FF:41:E8:0D:C6 
inet6 addr: fe80::2ff:8cff:fe6b:b830/64 Scope:Link
UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
RX packets:8129 errors:0 dropped:0 overruns:0 frame:0
TX packets:8504 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:1000
RX bytes:0 (0.0 b) TX bytes:378 (378.0 b) 

这个时候，再使用pppoeconf配置系统拨号。直接带tap0作参数，省得程序乱先找eth0，可以节约时间。

$ pppoeconf tap0 
┌──────┤ DSL CONNECTION FOUND ├──────┐ 
│                                                 │
│ I found an Access Concentrator on tap0\. Should I setup │ 
│ PPPOE for this connection?                  │ 
│                                          │ 
│            &lt;是&gt;       &lt;否&gt;            │ 
│                                                        │ 
└─────────────────────────────────────┘ 
│ If you continue with this program, the configuration file     │ 
│ /etc/ppp/peers/dsl-provider will be modified. Please make sure│ 
│ that you have a backup copy before saying Yes.                │ 
│                                                               │ 
│ Continue with configuration?                                  │ 
└─────────────────────────────────────┘ 
│ The DSL connection has been triggered. You can use the  | 
│ "plog" command to see the status or "ifconfig ppp0"     │ 
│ for general interface info.                       │ 
└─────────────────────────────────────┘ 


其结果就是产生/etc/ppp/peers/dsl-provider。以下是文件的有效部分。
$ cat /etc/ppp/peers/dsl-provider|grep ^[^#]
noipdefault 
usepeerdns 
defaultroute 
hide-password 
lcp-echo-interval 20 
lcp-echo-failure 3 
connect /bin/true 
noauth 
persist 
mtu 1492 
noaccomp 
default-asyncmap 
plugin rp-pppoe.so tap0 
user "CSD1873424"

另外需要设置/etc/resolv.conf，以修改DNS。也可以在其他想关如pppd中设置好。

现在可以正式联网了。

$ pon dsl-provider 
Plugin rp-pppoe.so loaded. 
RP-PPPoE plugin version 3.3 compiled against pppd 2.4.2 

外挂插件rp-pppoe.so 位于 /usr/lib/pppd/2.4.2，没有提示版本低了。也没有已经连接的提示。。。。 但是可以ping你的DNS看到已经联网。最好也看一下网络记录，以便有其他问题时，知道处理的方向。这时，可以看到系统又由tap0产生了一个实际的、系统使用的设备ppp0。

$ ifconfig
lo Link encap:Local Loopback
inet addr:127.0.0.1 Mask:255.0.0.0
inet6 addr: ::1/128 Scope:Host
UP LOOPBACK RUNNING MTU:16436 Metric:1
RX packets:166425 errors:0 dropped:0 overruns:0 frame:0
TX packets:166425 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:0
RX bytes:12416837 (11.8 MiB) TX bytes:12416837 (11.8 MiB)

ppp0 Link encap:Point-to-Point Protocol
inet addr:218.76.47.79 P-t-P:218.76.40.1 Mask:255.255.255.255
UP POINTOPOINT RUNNING NOARP MULTICAST MTU:1492 Metric:1
RX packets:6607 errors:0 dropped:0 overruns:0 frame:0
TX packets:6959 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:3
RX bytes:3728741 (3.5 MiB) TX bytes:946721 (924.5 KiB)

tap0 Link encap:Ethernet HWaddr 00:FF:8C:6B:B8:30
inet6 addr: fe80::2ff:8cff:fe6b:b830/64 Scope:Link
UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
RX packets:8129 errors:0 dropped:0 overruns:0 frame:0
TX packets:8504 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:1000
RX bytes:3972894 (3.7 MiB) TX bytes:1148641 (1.0 MiB)

$ plog ＃连接记录，可以知道出错时的情况。
Aug 17 19:15:34 localhost pppd[10109]: Using interface ppp0 
Aug 17 19:15:34 localhost pppd[10109]: Connect: ppp0 &lt;--&gt; tap0 
Aug 17 19:15:34 localhost pppd[10109]: Couldn"t increase MTU to 1500 
Aug 17 19:15:34 localhost pppd[10109]: Remote message: Code 13: Unable to find user in database
Aug 17 19:15:34 localhost pppd[10109]: PAP authentication failed 
Aug 17 19:15:34 localhost pppd[10109]: Couldn"t increase MTU to 1500 
Aug 17 19:15:34 localhost pppd[10109]: Couldn"t increase MRU to 1500 
Aug 17 19:15:34 localhost pppd[10109]: Connection terminated. 

忘记了一个（可能）很重要的地方。ubuntu在执行pppoeconf以后，并没有完全配置好设备。我手动强制改了一个地方。
$ sudo gedit /etc/ppp/peers/dsl-provider
#pty "/usr/sbin/pppoe -I ppp0 -T 80 -m 1452"
#pty "/usr/sbin/pppoe -I ppp0 -T 80 -m 1412"
#pty "/usr/sbin/pppoe -I ppp0 -T 80"

编辑配置文件，每次修改一项并开通（取消注释）。ppp0之前全部是eth0设备。没修改以前，每项都是注释掉了的。这是因为之前调试时，没有一次通过，也没有出ppp0。现在这些又注释掉了，还是可以出ppp0，不知道原因。希望其他机器上不需要出这么多转折。

另外我用/etc/ppp/peers/dsl-provider覆盖了/etc/ppp/peers/provider，因为后者是pon缺省的配置文件。这样联网时用pon，断开用poff。快捷多了。还作了个bash文件，包含eciadsl-start和pon就可以了，不过注意需要root的权限。如果使用普通用户身份，就是提示tap0出来了，也没有实际连接上。
~$ cat /bin/adsl
#!/bin/sh
sudo eciadsl-start
sleep 2
pon dsl-provider
#sleep 1
#ping -c 5 202.103.96.112

经过一段时间，突然觉得应该让modem在启动时就运行好。因为还有其他帐号的需要，当然是不太会的。
ln -s /etc/rcS.d/S44adsl /bin/adsl
这里的S44是因为系统说明S40（S40hotplug）以后才完成硬件的设置，就是说此时usb设备才认到。
这样，每次启动后，就是root下直接连通了。方便一些而已。