#!/bin/bash

function run {
  if ! pgrep $1; then
    $@ &
  fi
}

# load environment
source $HOME/.profile

# start polybar
(sleep 2; run $HOME/.config/polybar/launch.sh) &

# set keyboard map
xmodmap .config/Xmodmap

# cursor active at boot
xsetroot -cursor_name left_ptr &

# starting utility applications at boot time
run nitrogen --restore
run nm-applet
run clipmenud
run xfce4-power-manager
run volumeicon
numlockx on
run picom --config $HOME/.xmonad/scripts/picom.conf
# run lxsession
run lxpolkit
# run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run dunst
