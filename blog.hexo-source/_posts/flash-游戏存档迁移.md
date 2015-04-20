title: flash 游戏存档迁移
date: 2013-09-22 19:47
tags:
- game
- flash 
---
```
● cd .macromedia/
● fd kingdom
>>>> find . ! -path "*/.*" -iname "*kingdom*"
./Flash_Player/#SharedObjects/H7ETSHZZ/#localWithNet/eexp/Yunio/kingdom-rush-v1.1-cn.swf
● cd ./Flash_Player/#SharedObjects/H7ETSHZZ/#localWithNet/eexp/Yunio/kingdom-rush-v1.1-cn.swf
● scp krslot1.sol eexp-desktop.local:~/.macromedia/Flash_Player/#SharedObjects/XXXXXXXX/#localWithNet/eexp/Yunio/kingdom-rush-v1.1-cn.swf/
```
其中 XXXXXXXX 是对方机器相应的缓存目录。并且需要确定flash的启动目录也正确。

