#!/bin/bash

echo $*|sed "s/./\u&/g"|toilet -f smbraille
