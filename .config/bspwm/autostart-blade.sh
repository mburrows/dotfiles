#! /bin/bash

setxkbmap us
xrdb merge ~/.Xresources
xfsettingsd &
xfce4-power-manager &
nm-applet &
compton &
sxhkd &
$HOME/.config/polybar/launch.sh &
