#!/bin/bash

set -e

if [[ -n "$(pgrep stalonetray)" ]]; then
  killall stalonetray
else
  stalonetray &
fi

exit 0
