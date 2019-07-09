#! /bin/bash

xrdb merge ~/.Xresources
xfsettingsd &
xautolock -detectsleep -time 10 -locker "i3lock -c 000000" &
compton &
sxhkd -c $HOME/.config/sxhkd/$HOSTNAME-sxhkdrc &
$HOME/.config/polybar/launch.sh &
