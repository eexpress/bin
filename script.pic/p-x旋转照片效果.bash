#!/bin/bash

convert """$1""" -bordercolor white  -border 6 -bordercolor grey60 -border 1 -background none -rotate `perl -e 'print int rand(90)-45;'` -background  black \( +clone -shadow 60x4+4+4 \) +swap -background none -flatten """$1_旋转.png"""

