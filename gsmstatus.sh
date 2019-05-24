#!/bin/bash

# Send header to force i3bar to use JSON
echo '{"version":1}'

# Begin the endless array
echo '['

# Send an empty array first to make the loop simpler
echo '[]'

# Now send blocks of information forever...
while true :
do
	echo -n ','
	ssh -qt mburrows@pcomblin2 '/home/mburrows/scripts/gsmstatus -s --json sea seb set scc pea peb pet pcc'
	sleep 60
done
