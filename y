#!/bin/bash

f=${*:-note}
echo $f
#exit
echo -n "# ●" >>"$f"
date '+%Y-%m-%d_%H:%M:%S' >>"$f"
xclip -o >>"$f"
echo -e "\n" >>"$f"
#xclip -o >>${1:-摘录}

