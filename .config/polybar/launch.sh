#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
if [[ "$(hostname)" == "mblin" ]] ; then
    polybar -r left &
    polybar -r middle &
    polybar -r right &
else
    polybar -r master &
fi

echo "Bars launched..."
