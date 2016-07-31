#!/bin/bash

while [[ -n $1 ]]; do
echo "inklingreader -f \"$1\" -t \"${1/WPI/svg}\""
inklingreader -f "$1" -t "${1/WPI/svg}"
shift
done
