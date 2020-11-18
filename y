#!/bin/bash

f=${*:-x.摘录.x}
echo $f

echo -ne "#\t--------▶  " >>"$f"
date '+%F %T' | tr -d '\n' >>"$f"
echo -e " ◀ --------" >>"$f"

xclip -o  | sed '/'$HOSTNAME'/c--------' >>"$f"
echo -e "\n" >>"$f"

