#!/bin/bash


mplayer -identify -vo null -endpos 0 $1 2>/dev/null|grep -E "AUDIO:|VIDEO:"
