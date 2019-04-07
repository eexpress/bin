#!/bin/bash

DESTDIR="$HOME/.local/share/devhelp"
VALADOC="https://valadoc.org"

echo "Trying to create destination directory $DESTDIR …"
mkdir -p $DESTDIR
echo "Entering destination directory $DESTDIR …"
cd $DESTDIR
echo "Downloading archives…"
curl $VALADOC | grep devhelp | cut -c33- | sed 's/">.*$//' | xargs -I{} wget $VALADOC{}
echo "Trying to create book-directory $DESTDIR/books …"
mkdir books
echo "Moving archives to book-directory $DESTDIR/books …"
mv *.tar.bz2 books 
echo "Entering book-directory $DESTDIR …"
cd books 
echo "Uncompressing and unpacking archives …"
ls *.tar.bz2 | xargs -I{} tar xvfj {}
echo "Removing archives …"
rm *.tar.bz2
