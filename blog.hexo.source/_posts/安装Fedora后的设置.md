---
title: 安装Fedora后的设置
date: 2017-03-24 18:59:02
tags:
- fedora
---
## 安装 Fedora

### fstab
 
```
UUID=0f55ef91-9ff5-439e-b1bb-586430bc8251 /home         ext4    defaults        1 2
UUID=601bf370-5a87-4cd4-ab39-c319130b419f /home/eexpss/Game  ext4    defaults        1 2
```

###dnf

```
▶ sudo dnf copr enable librehat/shadowsocks
▶ sudo dnf install shadowsocks-qt5 retext inkscape gitg meld gvim nautilus-terminal pass qtpass autojump axel gnome-terminal-nautilus redshift-gtk 
▶ sudo rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm
▶ di unrar
▶ sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-nvidia.repo
▶ di nvidia-driver nvidia-settings kernel-devel akmod-nvidia vulkan.i686 nvidia-driver-libs.i686

```
dnf的输出格式，数据的组织和记录，都比apt效果好。`yumex-dnf`图形界面管理*安装细节*和*仓库*。dnf的查看历史信息尤其方便。增量安装不错。kernel自动维持3个，不用管理。一改以前rpm的坏印象，dnf比apt好啊。
> 增量 RPM 将 194.5 MB 的更新减少至 19.2 MB
keepass instead of qtpass

### 关联mplayer到媒体格式
查找有相关文件(*/命令，我猜出来的用法)的包，并安装。
```
▶ dnf provides */mimeopen
上次元数据过期检查：0:06:37 前，执行于 Sun Mar 26 06:29:30 2017。
perl-File-MimeInfo-0.27-5.fc25.noarch : Determine file type and open application
仓库        ：fedora
▶ mimeopen -d .mp4
	2) Other...
use application #2
use command: mplayer
```
其实是在 ~/.local/share/applications 建立desktop和defaults.list(mimeapps.list格式的文件)。


### extensions.gnome.org
extensions|gnome|org
-|-|-
NetSpeed|OpenWeather|Clipboard Indicator
Dynamic Panel Transparency(非最大化时，顶条透明)|TopIcons Plus(通知栏回顶部)| Dash to Panel
Toggle Touchpad(不工作)|Touchpad Indicator|Windows Blur Effects(背景窗口虚化)


遇到这个提示“*Attempt to postMessage on disconnected port*”，需要安装`chrome-gnome-shell`。
```
# dnf copr enable region51/chrome-gnome-shell
# dnf install chrome-gnome-shell
```
> 安装系统后，第一次又不需要，重启后就需要。奇怪。


### 设置光标主题
链接或者复制到.icons/Qetzal，tweak里面马上就可以选择，各处都有效。很爽啊。测试了，还不能使用~/.local/share/icons目录。

### 确保基本正常工作的设置
```
▶ l ~/文档/config/
fedora.bash_aliases  fedora.vimrc  font  gitconfig  mkd.css  proxy.pac  Qetzal  vim
```
各自链接到适当目录，就基本可以正常工作了。

### font
Courier-10-Pitch， URW-Bookman-L

### steam
`http://negativo17.org/steam/`

其实还有一个重要的源也在这里：`http://negativo17.org/repos/fedora-nvidia.repo`

	▶ sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo
	▶ sudo dnf -y install steam

> 登陆账号后，退出steam。链接老的游戏目录过去。

	▶ ln -sf '/home/eexpss/磁盘/eexp/.local/share/Steam/steamapps' '/home/eexpss/.local/share/Steam' 

其实这目录占用SSD，太麻烦。直接这样更好。
```
▶ lsm ~/.local/share/Steam
lrwxrwxrwx. 1 eexpss 30 05-02 11:17 /home/eexpss/.local/share/Steam -> /home/eexpss/磁盘/eexp/Steam
```

### nautilus图标缺省太大了
`▶ gsettings set org.gnome.nautilus.icon-view default-zoom-level standard`

### 安装openh264解码器(仅firefox) [seems not need in fedora 27, firefox works on youtube but not youku]

[wiki](https://fedoraproject.org/wiki/OpenH264)
```
$ sudo dnf config-manager --set-enabled fedora-cisco-openh264
$ sudo dnf install mozilla-openh264 gstreamer1-plugin-openh264
```
firefox的`about:addons->插件`里面，打开思科授权的opneh264编码器。可以看youtube了。

### 在Fedora上激活RPMFusion存储库(媒体解码器相关的软件都在这里)
	▶ sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

> https://rpmfusion.org/Configuration

安装了gstreamer1-plugins-ugly(包含了x264-libs)，还自动安装了另外一个multimedia(GStreamer Multimedia Codecs - *libav*)(must install in F27)的解码器，totem就都正常了。看来关键是激活这个软件仓库。


### 迁移密钥
	▶ cd oldmachine_home/.gnupg; cp pubring.gpg secring.gpg ~/.gnupg/
	▶ cd oldmachine_home/.ssh; cp id_rsa id_rsa.pub ~/.ssh/

### 删除密钥的一个用户标识
	▶ gpg --edit-key eexpress
	gpg> uid 5
	gpg> deluid

### 密钥的信任问题
qtpass中提示
> 系统错误：写入错误 QProcess::WriteError
gpg: WARNING: unsafe permissions on homedir '/home/eexpss/.gnupg'

~/.gnupg是一个链接。所以暂时不管。

> gpg: B55FE20388364032：没有证据表明这把密钥真的属于它所声称的持有者
gpg: [stdin]: encryption failed: 不可用公钥

忘记复制**trustdb.gpg**了，修复信任。以后迁移，复制全部(3个)*.gpg文件就好。
	▶ cd oldmachine_home/.gnupg; cp trustdb.gpg ~/.gnupg/

### 测试wayland
```
▶ loginctl list-sessions
   SESSION        UID USER             SEAT            
        c1         42 gdm              seat0           
         2       1000 eexpss           seat0           
2 sessions listed.
▶ loginctl show-session c1 -p Type
Type=wayland
▶ echo $XDG_SESSION_TYPE
wayland

```
### man less 颜色问题
设置LESS_TERMCAP无效。虽然most可替代，但是不灵活，并且没有粗体。需要下行设置。

	export GROFF_NO_SGR=1	#fix no color in Fedora 25

> some bug in new groff version 


### 制作fedora的u盘安装盘
之前，ubuntu的软件不认fedora的iso。没想去找其他软件，直接dd。用kvm测试下。
```
sudo umount /dev/sdc*
sudo dd if='/home/eexp/下载/ISO/Fedora-Workstation-Live-x86_64-25-1.3.iso' of=/dev/sdc bs=8M status=progress oflag=direct
1440743424 bytes (1.4 GB, 1.3 GiB) copied, 526.373 s, 2.7 MB/s
sudo kvm -hda /dev/sdc
```

### 家目录的链接
```
▶ lsm ~ ~/.local/share/|grep -E '(\->|:$)'|sed -e 's/.*:.../\t/' -e 's/->/\t\t->/'|grep -E '(:|磁盘)'
/home/eexpss:
	.wine 					-> /home/eexpss/磁盘/eexp/wine
	.ssh 					-> /home/eexpss/磁盘/eexp/.ssh/
	.gnupg 					-> /home/eexpss/磁盘/eexp/.gnupg/
	.password-store 		-> /home/eexpss/磁盘/eexp/.password-store
	bin 					-> /home/eexpss/磁盘/eexp/bin
/home/eexpss/.local/share/:
	Steam 					-> /home/eexpss/磁盘/eexp/Steam

▶ lsm ~ ~/.local/share/ ~/.local/share/nautilus/|grep -E '(\->|:$)'|sed -e 's/.*:.../\t/' -e 's/->/\t\t->/'|grep -E '(:|eexpss/bin)'
/home/eexpss:
	.icons 				-> /home/eexpss/bin/config/.icons/
	.vimrc 				-> /home/eexpss/bin/config/fedora.vimrc
	.bash_aliases 		-> /home/eexpss/bin/config/fedora.bash_aliases
	.proxy.pac 			-> /home/eexpss/bin/config/.proxy.pac
	.gitconfig 			-> /home/eexpss/bin/config/.gitconfig
	.vim 				-> /home/eexpss/bin/config/.vim
/home/eexpss/.local/share/:
	applications 		-> /home/eexpss/bin/config/.local+share+applications
/home/eexpss/.local/share/nautilus/:
	scripts 			-> /home/eexpss/bin/config/.local+share+nautilus+scripts


▶ find ~ -type l ! -path '/home/eexpss/磁盘' ! -path '/home/eexpss/bin' -lname '/home/eexpss/bin/config/*' -printf "%p  \t->\t%l\n" 
/home/eexpss/.local/share/applications  	->	/home/eexpss/bin/config/.local+share+applications
/home/eexpss/.local/share/nautilus/scripts  	->	/home/eexpss/bin/config/.local+share+nautilus+scripts
/home/eexpss/.vimrc  	->	/home/eexpss/bin/config/fedora.vimrc
/home/eexpss/.proxy.pac  	->	/home/eexpss/bin/config/.proxy.pac
/home/eexpss/.bash_aliases  	->	/home/eexpss/bin/config/fedora.bash_aliases
/home/eexpss/.icons  	->	/home/eexpss/bin/config/.icons/
/home/eexpss/.vim  	->	/home/eexpss/bin/config/.vim
/home/eexpss/.gitconfig  	->	/home/eexpss/bin/config/.gitconfig

```