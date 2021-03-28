#!/bin/bash

git log --oneline "$@"|head -n 5
hash=`git log --color=never --oneline "$@"|sed -n '2p'|cut -d' ' -f1`
git diff "$hash" "$@"
