#!/usr/bin/make -f


link: clean
	mkdir bin
	cd bin; \
		ln -s ../share/paste-img/pasteimg.pl . ;\
		ln -s ../share/paste-img/paste-img.pl . ;\
		mv pasteimg.pl pasteimg ;\
		mv paste-img.pl paste-img

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
	-mkdir -p deb/usr/share/paste-img
	-mkdir -p deb/usr/share/pixmaps
	cp -u *.desktop deb/usr/share/applications
	cp -u *.pl *.glade *.png deb/usr/share/paste-img
	cd deb/usr/share/pixmaps; \
	ln -sf ../paste-img/*.png . ;\
	cd ../../../..
	cd deb/usr/bin; \
	ln -sf ../share/paste-img/*.pl . ;\
	cd ../../..
	dpkg-deb -b deb .
#	rm -r deb




