#!/bin/bash

[ $# -eq 0 ] && echo "set-emblems \$file \$emblem.name1 [\$emblem.name2]" && echo -e "emblems locate in current theme directory. eg /usr/share/icons/Humanity/emblems/.\nall possible name:\nart marketing pictures camera money plan cool multimedia  presentation danger new sales desktop ohno shared development  OK sound documents package symbolic-link draft people system favorite personal urgent important photos videos\n" && exit
gvfs-set-attribute -t stringv $1 metadata::emblems $2 $3

