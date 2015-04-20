title: crontab调用gui软件。
date: 2007-02-23 13:02:03
tags:
---

$● crontab -e 
$● crontab -l 
# m h dom mon dow command 
11 20 * * * **<span style="color: red">export DISPLAY=:0 &amp;&amp;** /usr/bin/gqview