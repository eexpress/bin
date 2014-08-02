#!/bin/bash

# 去掉行号尾缀
sed -i 's/_[0-9]//g' flowchart.dot.svg
# 去掉文件名显示
sed -i '/flowchart.txt/d' flowchart.dot.svg 

