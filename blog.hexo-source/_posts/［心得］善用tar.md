title: ［心得］善用tar
date: 2006-08-03 13:08:47
tags:
---

系统的许多文件，尤其是配置文件，可能需要备份，以便在修改某些配置，又导致混乱的似乎可以恢复。对于经常玩配置（不仅仅指系统级别的配置，也包含用户级别的配置，比如自定义的目录图标的设置等），这些备份的工作尤其可以让你更加放心的玩。。。

系统的tar是个很好用的备份软件，命令虽然多，但是常用的也就几个。我整理一下，方便大家的使用。

首先，设置几个假名命令。先不需要问参数的意思。以后用熟了，自然就理解了。

$ cat .bashrc|grep "alias tar"
alias tar_delete="tar --delete -f "
alias tar_list="tar tf "
alias tar_update="tar uPvf "
alias tar_extract="tar xPvf "


这样，基本的tar命令就差不多了，而且确实就这4个已经足够了。

现在，可以备份一些文件。添加一个 fstab 和一个 xorg.conf 试试。这个命令是更新的意思，如果包里面已经有了一样的文件，会自动省略此文件的操作。当然如果新加入的文件更加新些，会把包的老文件冲掉，以保持新鲜。 :lol: 
$ tar_update sys.tar /etc/fstab /etc/X11/xorg.conf
/etc/fstab
/etc/X11/xorg.conf
查看一下内容。注意，添加的时候，我习惯带**全路径**，这是因为恢复的时候方便点。不需要使用 tar -C 这样的命令转操作路径了。不要以为全路径的操作麻烦，因为终端里面可以接受各种软件拖放过来的文件名。很方便的。
$ tar_list sys.tar
/etc/fstab
/etc/X11/xorg.conf
现在，删除一个。删除时候，也是全路径，可以先用 tar_list 看一下，找到需要删除的文件或者目录，鼠标中键粘贴整行就是。
$ tar_delete sys.tar /etc/X11/xorg.conf
$ tar_list sys.tar
/etc/fstab

最后是释放。更加简单。
$ tar_extract sys.tar

有了这几个假名命令，操作确实会方便很多。

你可以这样收集你的私人配置，比如目录图标（rox 的方式），这样，包里面就按照目录的结果把你所有的目录图标都收集到了一个 tar 文件里面了。&lt;labbor告诉的+号的用法&gt;
find ~ -iname ".DirIcon" -exec tar uPvf 目录图标.tar {} +

这些小的技巧，对于我这样的，经常同步2台机器配置的来说，是很方便的，因为我的2台机器的很多重要目录都是一模一样的。我的一个备份目录里面就都是些这样的备份包。
exp@eexpress:~/install/●备份$ l *.tar*
[.fvwm](2006-08-02 19-43-40).tar.gz  themes.tar.gz
icons.tar.gz                         目录图标.tar.gz
license of CW.tar.bz2                老的nautilus-scripts.tar.gz
system-config-backup.tar             [●脚本集合](2006-08-02 13-53-59).tar.gz

 :wink: