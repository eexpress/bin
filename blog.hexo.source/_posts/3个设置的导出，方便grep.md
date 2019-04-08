title: 3个设置的导出，方便grep
date: 2014-02-28 11:35
tags:
- gconftool
- gsettings
- dconf 
---
```
▶ gconftool --dump /
▶ gsettings list-recursively
▶ dconf dump /

▶ gsettings list-recursively|g auto-save
▶ gsettings get org.gnome.gnome-screenshot auto-save-directory
▶ gsettings set org.gnome.gnome-screenshot auto-save-directory '/home/eexp/桌面' 

```

