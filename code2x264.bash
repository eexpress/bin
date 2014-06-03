#!/bin/bash

log='/tmp/mencoder.log'
for i in $@; do
cd "`dirname $i`"
f=`basename $i`
echo ---------------- $f --------------
mencoder "$f" -o "x$f" 2>/dev/null
echo -------- | tee -a $log
ls -lFht "$f" "x$f" | tee -a $log
echo --------
gvfs-trash "$f"
done

