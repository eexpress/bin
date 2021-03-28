#!/bin/bash

git log -5 --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset %s' "$@"
hash=`git log --color=never --oneline "$@"|sed -n '2p'|cut -d' ' -f1`
git diff "$hash" "$@"
