title: fstab 实例
date: 2005-10-13 14:10:29
tags:
---

# /etc/fstab: static file system information. 
# 
# &lt;file system&gt; &lt;mount point&gt; &lt;type&gt; &lt;options&gt; &lt;dump&gt; &lt;pass&gt; 
proc /proc proc defaults 0 0 
/dev/hda3 / reiserfs notail 0 1 
/dev/hda2 /home ext3 defaults 0 2 
/dev/hda4 none swap sw 0 0 
/dev/hdc /media/cdrom0 udf,iso9660 ro,user,noauto 0 0 
/dev/sda /media/usb0 auto rw,user,noauto 0 0 
/dev/hda1 /media/win_c ntfs nls=utf8,umask=0222 0 0 
/dev/hda5 /media/win_d ntfs nls=utf8,umask=0222 0 0 
/dev/hda6 /media/win_e vfat utf8,umask=000 0 0 
LABEL=USB-FAT /media/USB-FAT vfat rw,user,utf8,auto,sync 0 0 
LABEL=USB-EXT3 /media/USB-EXT3 ext3 rw,user,auto,sync 0 0 
#sync:所有IO操作都要同步。 
#LABEL=:使用卷标指向磁盘。
//SERVER/共享目录 /media/服务器下共享目录 smbfs uid=1000,iocharset=utf8,codepage=cp936 0 0