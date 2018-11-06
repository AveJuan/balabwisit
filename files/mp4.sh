#!/bin/bash

timestamp=`date "+%m%d%Y%H%M"`
i=1
j=$(wc -l /root/.ssh/authorized_keys | awk -F' ' '{print $1}')

## This do while creates the list of ssh hex | fingerprint with it's corresponding label or name of owner..

while (( $i <= $j ));
do
  command=$(/bin/sed -n -e "$i"p /root/.ssh/authorized_keys > /var/log/balabwisit/pid/key"$i".$timestamp)
  command1=$(/usr/bin/ssh-keygen -lf /var/log/balabwisit/pid/key"$i".$timestamp | /bin/awk -F ' ' '{print $2}')
  command2=$(/bin/sed -n -e "$i"p /root/.ssh/authorized_keys | /bin/awk -F ' ' '{print $3}')
  /bin/echo "$command1 $command2" >> /var/log/balabwisit/pid/sshKeys.$timestamp
  sleep 1
  (( i++ ))
done

## if else condition that allows to get the list of recorded session accompanied by its fingerprint's owner.
## /var/log/balabwisit/pid/sshKeys.$timestamp

if [ -f /var/log/balabwisit/pid/sshKeys.$timestamp ]; then

  /bin/cat /var/log/balabwisit/pid/sshKeys.$timestamp > /var/log/balabwisit/pid/activeKeys
  /bin/ls -l /var/log/balabwisit/session/session* | /bin/awk -F' ' '{print $9}' | /bin/awk -F'/' '{print $6}' > /var/log/balabwisit/log/sessionList  # List session that has been recorded
  /bin/ps aux | grep -v grep | grep script | awk -F' ' '{print $15}' | awk -F'/' '{print $6}' > /var/log/balabwisit/log/activeSession # Show session that currently active
  /bin/sort /var/log/balabwisit/log/activeSession | uniq > /var/log/balabwisit/log/validActiveSessions # Since 'ps aux command show duplicate session name this will remove duplicates
  /bin/grep -vwF -f /var/log/balabwisit/log/validActiveSessions /var/log/balabwisit/log/sessionList > /var/log/balabwisit/log/recordedSession # This will remove Active session from already recorded one
  /bin/find /var/log/balabwisit/session/ -empty | awk -F'/' '{print $4}' > /var/log/balabwisit/log/invalidSession # Get all sessionFile that is empty
  /bin/grep -vwF -f /var/log/balabwisit/log/invalidSession /var/log/balabwisit/log/recordedSession > /var/log/balabwisit/log/finalList # remove the empty file from the recorded one.
  /bin/ls -l /var/log/balabwisit/key/session* | awk -F' ' '{print $9}' | awk -F'/' '{print $6}'> /var/log/balabwisit/log/sessionKey
  /bin/grep -f <( awk -F' ' '{print $1}' /var/log/balabwisit/log/finalList) /var/log/balabwisit/log/sessionKey > /var/log/balabwisit/log/sshkeyList
  /usr/bin/paste -d" " /var/log/balabwisit/log/finalList /var/log/balabwisit/log/sshkeyList > /var/log/balabwisit/log/keyNlist
  /usr/bin/python /var/log/balabwisit/scripts/convert.py ## This executes the convert.py which performs the convertion of the session file to mp4.

else

   /bin/echo "File could not be found, would you mind checking /var/log/balabwisit/pid/sshKeys.$timestamp" >> /dev/null

fi

### File Name and Purpose
#
# sessionList <- this contains all the contents of /var/log/balabwisit/session/
#
# activeSession <- this contains list of the sessions that are currently active or running.
#
# validActiveSession <- removes duplicate entry from activeSession, this now contains a single entry from 'ps' result.
#
# recordedSession <- this contains all sessions that has been recorded and no live/active sessions included.
#
# invalidSession <- this contains sessions that are empty, probably cause by sudden lost of connection while logging in.
#
# finalList <- this contains all the recorded session excluded the empty sessions listed in invalidSession
#
# sessionKey <- this is the contents of /var/log/balabwisit/key/
#
# sshkeyList <- this contains all the keys for the recorded session listed in finalList.
#
# keyNlist <- this is the combination of the ssh fingerprint and the recordedSession matching each other and combinining it line per line.
#
###
