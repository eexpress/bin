title: mp3添加封面
date: 2013-04-29 10:46
tags:
- lame
- mp3
- 封面
- 古筝 
---
![](/img/mp3fm.png)
```
● for i in *.mp3; do lame $i --ti Cover1.jpg --tt ${i%%.mp3} --ta 古代十大古筝名曲 ~/$i; done
```
