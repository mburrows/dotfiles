#! /bin/bash

xrdb merge ~/.Xresources
xfsettingsd &
xautolock -detectsleep -time 10 -locker "i3lock -c 000000" &
compton &
sxhkd &
$HOME/.config/polybar/launch.sh &
