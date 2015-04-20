title: 浪费一下午，居然是一个bug
date: 2009-12-29 13:12:36
tags:
---

● dog msg.pl 
use Net::DBus;
my $bus = Net::DBus-&gt;session-&gt;get_service("org.freedesktop.Notifications")
-&gt;get_object("/org/freedesktop/Notifications","org.freedesktop.Notifications");
my $id=$bus-&gt;Notify("eexp-msg", 5, "info", "Title", $ARGV[0], [], { }, 9000);
sleep 3;
print $id;
$bus-&gt;CloseNotification($id);

我说怎么关闭不了。原来在910，这还是bug。nnnnd
倒是使用Net::DBus，那截图脚本又更加独立些了。