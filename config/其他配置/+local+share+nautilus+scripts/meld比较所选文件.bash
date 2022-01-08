#!/bin/bash

files=($(echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS))
#~ echo "meld ${files[0]} ${files[1]}" > ~/tmp
meld ${files[0]} ${files[1]}
