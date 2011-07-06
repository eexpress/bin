#!/usr/bin/make -f


link:	clean
	/usr/bin/gcc `pkg-config --cflags --libs gtk+-2.0 gmodule-2.0` show_png.c -o show_png.run

clean:
	rm -rf deb

install: link
	-mkdir -p ${DESTDIR}/${PREFIX}
	cp -r share ${DESTDIR}/${PREFIX}
	cp -r bin ${DESTDIR}/${PREFIX}

deb:	clean
	-mkdir -p deb/DEBIAN
	cp -u control deb/DEBIAN
	-mkdir -p deb/usr/bin
	-mkdir -p deb/usr/share/applications
	-mkdir -p deb/usr/share/cairo-weather
	-mkdir -p deb/usr/share/pixmaps
	cp -u *.desktop deb/usr/share/applications
	cp -ur *.pl *.run config calendar/ weather-icon/ deb/usr/share/cairo-weather
	cp -u *.png deb/usr/share/pixmaps
	cd deb/usr/bin; \
	ln -sf ../share/cairo-weather/*.pl . ;\
	cd ../../..
	dpkg-deb -b deb .




