#!/bin/bash

cd "`dirname $0`"
pkill -9 lighttpd; lighttpd -f lighttpd.html.cgi.conf
