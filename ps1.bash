#!/bin/bash

# 用于构建彩色目录部分的函数
colorize_dir_path() {
    local path=$(echo "$1" | perl -pe "s|$HOME|~|")
    local colored_path=""
    local color_array=(18 242 22 202)
    local index=0
    IFS='/' read -ra ADDR <<< "$path"
    for i in "${ADDR[@]}"; do
        if [ "$i" != "" ]; then
        	local color=${color_array[$index]}
        	((index=(index+1)%${#color_array[@]}))
            colored_path+="\e[48;5;${color}m $i "
        fi
    done
    echo -e "\e[37m${colored_path}\e[0m"	#白色前景
}

colorize_dir_path "$PWD"

