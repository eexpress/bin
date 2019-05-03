#!/bin/bash

# $1 只是文件名前缀相同部分
ls $1* | perl -ne 'chomp; print "file '\''$_'\''\n";' > ffmpeg-merge-file-list
ffmpeg -f concat -safe 0 -i ffmpeg-merge-file-list -c copy $1.merge.mp4

