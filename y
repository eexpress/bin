#!/bin/bash

f=${1:-摘录}
echo $f
echo -e "# ● `date '+%Y-%m-%d_%H:%M:%S'`\n`xsel -o`\n" >>"$f"
#xsel -o >>${1:-摘录}

