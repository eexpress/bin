title: Graphviz Dot 生成 svg/png 的菜单
date: 2014-10-21 12:37:02
tags:
- graphviz
- dot
- nautilus
- desktop
---
建立一个nautilus的右键菜单。
```
▶ cat ~/.local/share/applications/graphviz.dot.desktop 
[Desktop Entry]
Name=Graphviz Dot 生成 svg/png
Exec=/bin/bash -c "f=%U; dot -Tsvg $f -o $f.svg; dot -Tpng $f -o $f.png"
Icon=/home/eexp/图片/icon/graphviz.png
Terminal=false
Type=Application
Categories=GTK;GNOME;Graphic;
MimeType=text/vnd.graphviz
```
> 发现一个奇特的问题，Exec行调用%U，居然只能调用一次。测试好久才发现，只好先把文件名纳入变量。还没有处理路径空格，暂时先这样。

