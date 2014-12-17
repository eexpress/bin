#!/bin/bash

cd $TR_TORRENT_DIR
dir="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
dest="/home/eexp/视频/restricted"
dest1="/media/eexp/32G/restricted/"
if [ -d $dest1 ]; then dest=$dest1; fi
echo $dir>>/tmp/bt_dir.log
#cd $dir
cd $TR_TORRENT_DIR
mv *.avi *.mp4 *.wmv *.mkv $dest
mv */*.avi */*.mp4 */*.wmv */*.mkv $dest
#[ $? != 0 ] && exit
#rm -r $TR_TORRENT_NAME
gvfs-trash $TR_TORRENT_NAME
cd $dest
for i in *.avi *.mp4 *.wmv *.mkv; do
rename 's/.*\..*\.cc-//; s/.*3xplanet_//; s/^[\d\.]*-//' $i
done

#第一列为id，第二列为百分比。
transmission-remote -l|awk '$2=="100%" {print $1}'|while read i
do echo "remove torrent. id: $i">>/tmp/bt_dir.log
transmission-remote -t$i -r
done
