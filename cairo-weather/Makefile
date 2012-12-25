#!/usr/bin/make -f

clean:
	rm -rf deb

deb:	clean
	-mkdir -p deb/DEBIAN
	cp -u control deb/DEBIAN
	-mkdir -p deb/usr/bin
	-mkdir -p deb/usr/share/applications
	-mkdir -p deb/usr/share/cairo-weather
	-mkdir -p deb/usr/share/pixmaps
	cp -u cairo-weather deb/usr/bin
	cp -u cairo-weather.desktop deb/usr/share/applications
	cp -u config/ deb/usr/share/cairo-weather
	cp -ur weather-icon/ deb/usr/share/cairo-weather
	cp -ur calendar/ deb/usr/share/cairo-weather
	cp -u cairo-weather.png deb/usr/share/pixmaps
	dpkg-deb -b deb .

