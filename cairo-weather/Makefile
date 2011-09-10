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
	cp -u *.desktop deb/usr/share/applications
	cp -ur *.pl config calendar/ weather-icon/ deb/usr/share/cairo-weather
	cp -u *.png deb/usr/share/pixmaps
	cd deb/usr/bin; \
	ln -sf ../share/cairo-weather/*.pl . ;\
	cd ../../..
	dpkg-deb -b deb .




