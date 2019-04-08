title: 将wacai的数据转到Toshl
date: 2014-02-03 20:32
tags:
- 记账
- toshl
- wacai 
---
![](/img/toshl.jpg)
Toshl胜在简洁。wacai只能导出xls，而且还只能一次一年，蛋疼不。自己转成csv，再整理下格式。其实只需要 日期/类型(tags)/金额。
破wacai的金额，可能是“3,456.00”。先要预先处理下。
```
▶ sed -i 's/\"\(.*\),\(.*\)\"/\1\2/g' wacai_*.csv
▶ awk -F ',' '{printf "%s,%s,%s,%s\n",$8,$2,$9,$11}' wacai_*.csv|sed 's/\ /,/g'>wacai.csv
```
在建议Toshl支持导入csv。

