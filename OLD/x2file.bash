#!/bin/bash

xclip -o -selection clipboard > $1
sed -i 's/\r$//' $1
