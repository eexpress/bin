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
合并视频，同类编码的才能正确合并。其实可以不输出单引号。perl单行输出单引号，需要技巧。`'\''`或者`\047`。
```
ls *.avi | perl -ne 'chomp; print "file $_";' >/tmp/ffmpeg-merge-file-list
ffmpeg -f concat -i /tmp/ffmpeg-merge-file-list -c copy Joined.mp4

ls *.avi | perl -ne 'chomp; print "file '\''$_'\''\n";' | ffmpeg -f concat -i - -c copy Joined.mp4
直接管道，出奇怪的错误
[file @ 0x556f70c00a20] Protocol not on whitelist 'crypto'!
[concat @ 0x556f70bf7400] Impossible to open 'xxx.mp4'
pipe:: Invalid argument

```
截取一个片段。
```
▶ ffmpeg -i input.avi -ss 00:05 -t 00:10 -c copy output.avi
```
截取5张图片，xsel -b就是在nautilus里面复制一下文件（将文件名复制到剪贴板）。
```
▶ ffmpeg -i `xsel -b` -ss 00:00:08 -q:v 2 -vframes 5 image-%d.jpg
```
列出所有视频的编码和尺寸。
```
▶ for i in *.avi *.mp4; do printf "%-26s\t" $i; ffprobe -hide_banner $i 2>&1|perl -ne '/Video: [^ ]*/ && print "$&\t"; /\s\d{3,}x\d*\b/ && printf "Size:%-12s",$&;/Audio: [^ ]*/ && print $&; END{print "\n"};'; done
```
or
```
▶ for i in *.avi *.mp4; do ffprobe -hide_banner $i 2>&1|perl -ne '$f=$1 if /from (.*)/; $v=$1 if /Video: ([^ ]*)/; $s=$& if /\s\d{3,}x\d*\b/; $a=$1 if /Audio: ([^ ]*)/; END{printf "%-38s\t%-8s%-8s%s\n",$f,$v,$a,$s};'; done
```
批量转换编码和尺寸。
```
▶ for i in *; do ffmpeg -i $i -c:v mpeg4 -q:v 4 -c:a libmp3lame -vf scale=720x400 ../720x400/$i.mp4; done
```
