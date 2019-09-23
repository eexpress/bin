# 命令行参数

`-i[extension]`     edit <> files in place (makes backup if extension supplied)
>和sed一样。直接编辑文件。带扩展名，就产生备份文件，比如`-i.bak`。
```
perl -p -i.bak -e 's/\bfoo\b/bar/g' *.c
perl -pie 's/\bfoo\b/bar/g' *.c #不要备份
```

`-n`                assume "while (<>) { ... }" loop around program

`-p`                assume loop like -n but print line also, like sed
>自动循环+自动输出，相当于 while(<>) { 脚本; print; }

```
perl -F: -lane 'print "@F[0..4] $F[6]\n"' /etc/passwd
perl -lane 'print $F[4] + $F[-2]'
```
>类似awk。

`-a`                autosplit mode with -n or -p (splits $_ into @F)
>自动分隔模式，用空格分隔$_并保存到@F中。相当于@F = split ”。分隔符可以使用-F参数指定

`-l[octal]`         enable line ending processing, specifies line terminator
>对输入内容自动chomp，对输出内容自动添加换行

```
perl -ne 'print if /^START$/ .. /^END$/' file
perl -ne 'print unless /^START$/ .. /^END$/' file 	#不显示start和end之间的行
```

`-00` 段落模式，即以连续换行为分隔符

`-0777` 禁用分隔符，即将整个文件作为一个记录


---

说明|命令实例
--|--
显示开头50行：|`perl -pe 'exit if $. > 50′ file`
不显示开头10行：|`perl -ne 'print unless 1 .. 10′ file`
显示15行到17行：|`perl -ne 'print if 15 .. 17′ file`
每行丢弃前10个字符：|`perl -lne 'print substr($_, 10) = “”' file`
查找不含comment字符串的行：反向的grep，即grep -v。|`perl -ne 'print unless /comment/' duptext`
文件按行排序：|`perl -e 'print sort <>' file`
文件按行反转：|`perl -e 'print reverse <>' file`
一次性读入全部内容。修改缺省分行符|`perl -e 'local $/=undef; $_=<>; s/\n/, /g; print $_;' 名字.txt`

---
%s/['']/'/g
%s/[""]/"/g

