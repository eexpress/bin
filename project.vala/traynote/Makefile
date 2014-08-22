#!/usr/bin/make -f


clean:
	rm -rf deb

deb:	clean
	-mkdir -p deb/DEBIAN
	cp -u control deb/DEBIAN
	-mkdir -p deb/usr/bin
	cp -u traynote deb/usr/bin
	-mkdir -p deb/usr/share/applications
	cp -u traynote.desktop deb/usr/share/applications
	-mkdir -p deb/usr/share/traynote
	cp -u -r icons/ deb/usr/share/traynote
	-mkdir -p deb/usr/share/pixmaps
	cp -u traynote.png deb/usr/share/pixmaps
	-mkdir -p deb/usr/share/locale/zh_CN/LC_MESSAGES
	cp -u traynote.mo deb/usr/share/locale/zh_CN/LC_MESSAGES
	dpkg-deb -b deb .




