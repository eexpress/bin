#! /bin/bash

png="/tmp/ocr.png"
txt="/tmp/ocr"

gnome-screenshot -a -f $png
tesseract $png $txt -l chi_sim #中文
zenity --text-info --title="文字识别结果" --filename=$txt".txt"
