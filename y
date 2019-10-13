#!/bin/bash

f=${*:-x.摘录.x}
echo $f
#exit
echo -ne "#\t--------▶  " >>"$f"
date '+%Y-%m-%d_%H:%M:%S' | tr -d '\n' >>"$f"
echo -e " ◀ --------\n" >>"$f"
#xclip -o | sed '/'"$HOSTNAME"'/d;G' >>"$f"
#xclip -o | sed 's/^.* 🡺 .*//' >>"$f"
xclip -o | sed '/🡺 .*'"$HOSTNAME"'/c\\n' >>"$f"
echo -e "\n" >>"$f"
#xsel -o >>${1:-摘录}

