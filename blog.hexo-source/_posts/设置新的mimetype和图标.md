---
title: 设置新的mimetype和图标
date: 2017-03-04 17:54:45
tags:
- mimetype
- icon
---

## Create New Mimetype
```
▶ cat /usr/share/mime/packages/stl.xml
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
	<mime-type type="application/x-STereoLithography">
	<comment>STereoLithography file</comment>
	<glob pattern="*.stl" />
	</mime-type>
</mime-info>

▶ mimetype '/home/eexp/文档/freecad/cigar0.stl' 
/home/eexp/文档/freecad/cigar0.stl: application/x-STereoLithography

▶ sudo update-mime-database /usr/share/mime/
```

## Add Icon to mimetype.

1. found mimetype name, eg **application/x-extension-fcstd**:

		▶ mimetype .fcstd
		.fcstd: application/x-extension-fcstd
	
1. found a suitable svg file and cp to here **/usr/share/icons/hicolor/scalable/mimetype**, and the file name must be **application-x-extension-fcstd** which just like the mimetype name:

		▶ sudo cp ~/FreeCAD-logo.svg /usr/share/icons/hicolor/scalable/mimetypes/application-x-extension-fcstd.svg
		▶ sudo cp ~/Dolphin_triangle_mesh.svg /usr/share/icons/hicolor/scalable/mimetypes/application-x-STereoLithography.svg


1. update icon cache with **-f**, (here has the index.theme file):

		▶ sudo gtk-update-icon-cache /usr/share/icons/hicolor/ -f

1. nautilus change file icon **immediately**.

![](/img/mimetype.png)
