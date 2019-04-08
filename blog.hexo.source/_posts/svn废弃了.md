title: svn废弃了
date: 2010-02-17 16:02:37
tags:
- svn
---

perl -e "@l=`locate svn`; map {chomp; -d &amp;&amp; /.svn$/ &amp;&amp; `sudo rm -r $_`;} @l;"
