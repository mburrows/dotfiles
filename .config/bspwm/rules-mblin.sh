#! /bin/bash

bspc rule -a Gimp desktop='^8' state=floating follow=on
# bspc rule -a Google-chrome desktop='^1' follow=on
bspc rule -a Emacs desktop='^4' follow=on
bspc rule -a Thunar state=floating
