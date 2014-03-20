#!/bin/bash

aptitude search '~i!~n^lib!~ndev$' | cut -b 5- | sed 's/\ .*//' >~/Ubuntu\ One/pkg-`hostname`
