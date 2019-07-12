#! /bin/bash

xrdb merge ~/.Xresources

pkill xfsettingsd
xfsettingsd &

pkill xfce4-power-manager
xfce4-power-manager &

pkill xautolock
xautolock -detectsleep -time 10 -locker "i3lock -c 000000" &

pkill nm-applet
nm-applet &

pkill compton
compton &

pkill sxhkd
sxhkd -c $HOME/.config/sxhkd/$HOSTNAME-sxhkdrc &

setxkbmap --layout us

$HOME/.config/polybar/launch.sh &
