---
title: 手动设置文件的徽章emblem图标
date: 2017-03-22 21:01:21
tags:
- emblem
- nautilus
- gnome2
---
怀念gnome2的一些特性。某些文件想设置**徽章**emblem。测试了半天才搞清楚。

1. 看文件的可设置属性和当前值。

		▶ gvfs-info -a metadata proxy.pac
		URI：file:///home/eexp/proxy.pac
		属性：
		  metadata::custom-icon: [/usr/share/icons/hicolor/16x16/apps/virtualbox.png]
		  metadata::emblems: [OK, important]
		  metadata::pluma-spell-language: en_US

1. 手动设置。根据当前主题，可找到可用徽章图标文件，比如：`/usr/share/icons/Humanity/emblems/`。设置emblems容易，设置custom-icon一直不显示。nautilus需要新开才看到效果。


		▶ gvfs-set-attribute -t stringv $file/dir.name metadata::emblems $emblems.name


