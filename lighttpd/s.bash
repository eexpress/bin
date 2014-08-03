#!/bin/bash

pkill -9 lighttpd; lighttpd -f lighttpd.html.cgi.conf
