#! /bin/bash

xrdb merge ~/.Xresources
xfsettingsd &
xfce4-power-manager &
xautolock -detectsleep -time 10 -locker "i3lock -c 000000" &
nm-applet &
compton &
sxhkd -c $HOME/.config/sxhkd/$HOSTNAME-sxhkdrc &
setxkbmap --layout us
$HOME/.config/polybar/launch.sh &
