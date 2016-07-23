---
title: ffmpeg常用命令总结
date: 2016-07-23 13:21:00
tags:
- ffmpeg
---
归类。按照尺寸建立目录，并移动视频到目录。
```
for i in *; do s=`ffmpeg -i "$i" 2>&1|grep -o '[0-9]\{3,\}x[0-9]*'`; mkdir $s; mv "$i" "$s"; done
```
转换视频编码到mpeg4+mp3，bitrate大概维持在1kkb/s以上。其中-q非常重要，参数从1-31，1是最高质量。在这里使用-crf完全无效。
```
▶ ffmpeg -i input.avi -c:v mpeg4 -q:v 4 -c:a libmp3lame output.mp4
```
合并视频，同类编码的才能正确合并。
```
ls *.avi | perl -ne 'print "file $_"' | ffmpeg -f concat -i - -c copy Joined.mp4
```
截取一个片段。
```
▶ ffmpeg -i input.avi -ss 00:05 -t 00:10 -c copy output.avi
```
列出所有视频的编码和尺寸。
```
▶ for i in *.avi *.mp4; do printf "%-30s\t" $i; ffprobe -hide_banner $i 2>&1|perl -ne '/Video: [^ ]*/ && print "$&\t"; /\s\d{3,}x\d*\s/ && print "Size:$&\t";/Audio: [^ ]*/ && print $&; END{print "\n"};'; done
```
批量转换编码和尺寸。
```
▶ for i in *; do ffmpeg -i $i -c:v mpeg4 -q:v 4 -c:a libmp3lame -vf scale=720x400 ../720x400/$i.mp4; done
```
