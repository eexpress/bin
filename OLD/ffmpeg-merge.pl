#!/usr/bin/perl

use 5.10.0;
#~ 安装当前目录下视频的尺寸，合并所有视频。
unlink glob("video-*.list");
while (glob("*.{mp4,mkv}")){
	next if /^ffmpeg-merge-.*\.mp4/;	#跳过合并的结果文件
	$f = $_;
	$_ = `ffmpeg -i "$f" 2>&1`;
	/\d{2,5}x\d{2,5}/s;
#~ 按照尺寸，建立目录，移动文件到目录。
	mkdir "$&" if ! -d "$&";
	rename "$f", "$&/$f" or die;
	#~ push @info, "$&,$&/$f";
#~ 建立适合ffmpeg的文件列表。
	open OUT,">>","video-$&.list" or die;
	say OUT "file \'$&/$f\'" or die;
	close OUT;
}

for(glob("video-*.list")){
	/video-(.*)\.list/;
	say "============$1===========";
	`ffmpeg -f concat -i $_ -c copy ffmpeg-merge-$1.mp4`;
	#~ avidemux合并的没问题。ffmpeg合并的，某些视频会卡住不动。
	#~ 只是avidemux只能Ctrl-A一个一个的文件增加。
}
