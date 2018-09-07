#!/bin/bash

convert """$1""" -edge 1 -negate -normalize -colorspace Gray -blur 0x.5 -contrast-stretch 0x50% """$1_边线.jpg"""

convert """$1""" -colorspace gray \
          \( +clone -blur 0x2 \) +swap -compose divide -composite \
          -linear-stretch 5%x0%  """$1_边线1.jpg"""
