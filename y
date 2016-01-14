#!/bin/bash

f=${*:-note}
echo $f
#exit
echo -n "# ●" >>"$f"
date '+%Y-%m-%d_%H:%M:%S' >>"$f"
xsel -o >>"$f"
echo -e "\n" >>"$f"
#xsel -o >>${1:-摘录}

