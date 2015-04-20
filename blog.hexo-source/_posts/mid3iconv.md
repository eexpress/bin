title: mid3iconv原来还算有效。
date: 2007-02-23 16:02:00
tags:
---

以前的转id3的软件的坏印象，一直影响了我。今天试试这个，竟然似乎可以。
mid3iconv  -e GBK *.mp3

鉴于id3本来不支持unicode，而且版本繁多，有些错误难免。

Updating 情凭谁来定错对.mp3
Traceback (most recent call last):
  File "/usr/bin/mid3iconv", line 136, in ?
    main(sys.argv)
  File "/usr/bin/mid3iconv", line 126, in main
    update(options, args)
  File "/usr/bin/mid3iconv", line 88, in update
    else: id3.save(filename)
  File "/usr/lib/python2.4/site-packages/mutagen/id3.py", line 320, in save
    framedata = map(self.__save_frame, self.values())
  File "/usr/lib/python2.4/site-packages/mutagen/id3.py", line 397, in __save_frame
    if len(str(frame)) == 0: return ""
  File "/usr/lib/python2.4/site-packages/mutagen/id3.py", line 1132, in __str__
    def __str__(self): return self.__unicode__().encode("utf-8")
  File "/usr/lib/python2.4/site-packages/mutagen/id3.py", line 1133, in __unicode__
    def __unicode__(self): return ",".join([stamp.text for stamp in self.text])
AttributeError: "unicode" object has no attribute "text"


对于乱码的文件名，一次转，先测试最好（省略--notest）
convmv -f GBK -t utf8 [B]--notest[/B] *.mp3