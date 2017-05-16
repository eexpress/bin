#!/bin/bash

file=`echo -n $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|sed 's/\x0A//g'`
baobab "$file"
