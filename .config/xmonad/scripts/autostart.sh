#!/bin/bash

function run {
  if ! pgrep $1; then
    $@ &
  fi
}

# Load Environment
source $HOME/.profile

# Start Polybar
(sleep 2; run $HOME/.config/polybar/launch.sh) &

# Keyboard Settings
xmodmap .config/Xmodmap
numlockx on

# Cursor At Boot
xsetroot -cursor_name left_ptr &

# Start Utilities
run nitrogen --restore
run nm-applet
run clipmenud
run xfce4-power-manager
run volumeicon
run picom --config $HOME/.xmonad/scripts/picom.conf
run lxpolkit
run dunst
