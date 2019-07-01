#! /bin/bash

xrdb merge ~/.Xresources
xfsettingsd &
compton &
sxhkd &
$HOME/.config/polybar/launch.sh &
