#!/bin/bash

dir=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|head -n 1|sed 's/\x0A//g'`
[ -f "$dir" ] && dir=`dirname "$dir"`
baobab "$dir"
