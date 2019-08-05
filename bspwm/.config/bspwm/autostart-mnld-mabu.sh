#! /bin/bash

#xrdb merge ~/.Xresources
#
#pkill xautolock
#xautolock -detectsleep -time 10 -locker "i3lock -c 000000" &
#
#pkill compton
#compton &

pkill sxhkd
sxhkd -c $HOME/.config/sxhkd/$(hostname -s)-sxhkdrc &

#pkill xfsettingsd
#fsettingsd &

#$HOME/.config/polybar/launch.sh &

setxkbmap us
