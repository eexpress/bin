#!/bin/bash

convert """$1""" \( +clone -threshold -1 -virtual-pixel black -spread 50 -blur 0x3 -threshold 50% -spread 2 -blur 0x.7 \) +matte -compose Copy_Opacity -composite """$1_破纸.png"""

