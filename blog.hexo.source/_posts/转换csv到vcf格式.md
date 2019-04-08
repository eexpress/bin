title: "转换csv到vcf格式"
date: 2015-05-24 18:32:34
tags:
- csv
- vcf
---
通讯录各大邮箱都不兼容，导入导出非常麻烦，各种丢失和不兼容。手机导出还是2.1格式的vcf。干脆使用csv格式，至少修改编辑可以随便使用喜欢的软件。手机导入还是只能vcf。
写了一个perl脚本转换，只转换主要的字段，当然可以随便增加字段对应，因为那就是一个二维数组表。
[下载 csv2vcf3.pl](https://github.com/eexpress/eexp-bin/blob/master/csv2vcf3.pl)
```
csv2vcf3.pl xx1.csv xx2.csv > yyy.vcf
```
