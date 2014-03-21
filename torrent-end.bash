#!/bin/bash

dir="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
dest="/home/eexp/视频/restricted"
dest1="/media/eexp/32G/restricted/"
if [ -d $dest1 ]; then dest=$dest1; fi
cd $dir
mv *.avi *.mp4 *.wmv $dest
[ $? != 0 ] && exit
cd ..
#rm -r $TR_TORRENT_NAME
gvfs-trash $TR_TORRENT_NAME
cd $dest
for i in *.avi *.mp4 *.wmv; do
rename 's/3xplanet_//;s/^[\d\.]*-//' $i
done

