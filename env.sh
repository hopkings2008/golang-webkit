#!/bin/bash
set -e

DISPLAY=:1
XVFB=/usr/bin/Xvfb
XVFBARGS="$DISPLAY -ac -screen 0 1024x768x16 +extension RANDR"
PIDFILE="/var/xvfb.pid"

export DISPLAY=$DISPLAY

nohup $XVFB $XVFBARGS > /dev/null &
sleep 1

#/gopath/bin/app
