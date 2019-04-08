title: flash存档在~/.macromedia下面的中文目录格式
date: 2013-12-17 22:11
tags:
- flash
- sol
- game
- swf
- macromedia 
---
```
● echo 公共的|uni2ascii -a J|sed 's/%\(.\)/\1#/g'
E#58#5A#CE#58#5B#1E#79#A8#4
● fd kr sol
./Flash_Player/#SharedObjects/6EGT35HN/#localWithNet/eexp/E#58#5A#CE#58#5B#1E#79#A8#4/game-swf/kingdom-rush/kr-frontiers-v1.1-cn.swf/krslot1.sol
./Flash_Player/#SharedObjects/6EGT35HN/localhost/eexp/E#58#5A#CE#58#5B#1E#79#A8#4/game-swf/kingdom-rush/kingdom-rush-v1.13.swf/krslot1.sol
● fd Protect sol
./Flash_Player/#SharedObjects/6EGT35HN/#localWithNet/eexp/E#58#5A#CE#58#5B#1E#79#A8#4/game-swf/E#4B#F9#D#/E#58#DA#BE#89#09#DE#58#D9#C.swf/ProtectTheCarrot.sol
● echo 'E#4B#88#BE#8B#DB#D'|sed 's/\(.\)#/%\1/g'|ascii2uni -a J
下载
```
