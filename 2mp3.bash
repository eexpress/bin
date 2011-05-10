#!/bin/bash

mplayer -vo null -ao pcm $1
lame audiodump.wav $1.mp3
rm audiodump.wav

