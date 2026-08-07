#!/bin/bash

#批量改名，参数1支持perlre写法，可用一直连写，其余参数为扩展文件名。
#⭕ rename.bash 's/\.bash$/\.bash\.txt/' *.bash
regex=$1
shift
echo "----------Preview-------------"
cnt=1
for i in """$@"""; do s[$cnt]=$i; d[$cnt]=`echo $i|perl -pe "$regex"`; if [[ ${s[$cnt]} == ${d[$cnt]} ]]; then continue; fi; echo -e "${s[$cnt]}\t->\t${d[$cnt]}"; ((cnt++)); done

if [[ $cnt -eq 1 ]]; then echo "No File Need Rename."; exit; fi
echo "----------Rename?-------------"
echo "Comfirm: press SPACE/ENTER. Other keys Cancel."
read -s -n 1 y
if [[ $y == '' ]]; then
	echo "Start Rename..."
	for (( i=1; i<$cnt; i++ )) ; do
	echo "mv ${s[$i]} ${d[$i]}"
	mv "${s[$i]}" "${d[$i]}"
	done
else echo "Cancel."; fi

