#! /bin/bash

setxkbmap us
xrdb merge ~/.Xresources
xfsettingsd &
xfce4-power-manager &
xautolock -detectsleep -time 10 -locker "i3lock -c 000000" &
nm-applet &
compton &
sxhkd &
$HOME/.config/polybar/launch.sh &
