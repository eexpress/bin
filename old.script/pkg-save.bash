#!/bin/bash

aptitude search '~i!~n^lib!~ndev$' | cut -b 5- | sed 's/\ .*//' >~/文档/pkg-`hostname`
