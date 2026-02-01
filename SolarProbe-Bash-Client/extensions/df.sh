#!/bin/sh
set -eu

# Purpose: Monitor Linux disk space and send an email alert to $ADMIN
ALERT_YELLOW=10 # alert level 
ALERT_RED=90 # alert level 

COLUMN=disk 	# Name of the column
COLOR=green		# By default, everything is OK
MSG="All is OK"

df -H | grep -vE '^Filesystem|Dateisystem|tmpfs' | awk '{ print $5 " " $1 }' | while read -r output;
do
  #echo "$output"

  usep=$(echo "$output" | awk '{ print $1}' | cut -d'%' -f1 )
  partition=$(echo "$output" | awk '{ print $2 }' )

  echo "$partition: $usep% ($ALERT_YELLOW)"

  if [ "$usep" -ge $ALERT_RED ]; then
    COLOR=red
    MSG="Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)"
  elif [ "$usep" -ge $ALERT_YELLOW ]; then
    COLOR=yellow
    MSG="Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)"
  fi
done


# Tell Xymon about it
#echo "$XYMON $XYMONSRV status $MACHINE.$COLUMN $COLOR $(date)
#
#${MSG}
#"

echo "$COLUMN $COLOR $(date) $MSG"

exit 0

