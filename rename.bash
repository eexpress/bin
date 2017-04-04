#!/bin/bash

regex=$1
shift
echo "----------Preview-------------"
cnt=1
for i in """$@"""; do s[$cnt]=$i; d[$cnt]=`echo $i|perl -pe "$regex"`; echo -e "${s[$cnt]}\t->\t${d[$cnt]}...."; ((cnt++)); done

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

