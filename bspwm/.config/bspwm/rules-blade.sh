#! /bin/bash

bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium-browser desktop='^2' follow=on
bspc rule -a Emacs desktop='^3' follow=on
bspc rule -a Thunar state=floating
