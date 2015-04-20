title: SSD Trim
date: 2014-04-23 20:21
tags:
- ssd
- trim 
---
```
▶ cat /sys/block/sdb/queue/rotational
0
▶ sudo hdparm -I /dev/sdb | grep "TRIM supported"
* Data Set Management TRIM supported (limit 8 blocks)
▶ sudo fstrim -v /
/: 20905598976 bytes were trimmed
```
Trim的作用
　　原本在机械硬盘上，写入数据时，系统会通知硬盘先将以前的擦除，再将新的数据写入到磁盘中。而在删除数据时，系统只会在此处做个标记，说明这里应该是没有东西了，等到真正要写入数据时再来真正删除，并且，做标记这个动作，会保留在磁盘缓存中，等到磁盘空闲时再执行。这样一来，磁盘需要更多的时间来执行以上操作，速度当然会慢下来。
　　而当系统识别到SSD并确认SSD支持Trim后，在删除数据时，会不向硬盘通知删除指令，只使用Volume Bitmap来记住这里的数据已经删除。Volume Bitmap只是一个磁盘快照，其建立速度比直接读写硬盘去标记删除区域要快得多。这一步就已经省下一大笔时间了。然后再是写入数据的时候，由于NAND闪存保存数据是纯粹的数字形式，因此可以直接根据Volume Bitmap的情况，向快照中已删除的区块写入新的数据，而不用花时间去擦除原本的数据。

