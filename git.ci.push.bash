#!/bin/bash

msg=${*:-`date '+%F %T'`}
git ci -a -m "$msg"; git push

