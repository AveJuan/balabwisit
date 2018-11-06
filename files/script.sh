if [ "x$SESSION_RECORD" = "x" ]
then
i=1
j=$(wc -l .ssh/authorized_keys | awk -F' ' '{print $1}')
teka=$(date +%e)
host=$(hostname)
timestamp=`date "+%m%d%Y%H%M%S"`
output=/var/log/balabwisit/session/session.$USER.$timestamp
timing=/var/log/balabwisit/time/session.$USER.$timestamp
sshkey=/var/log/balabwisit/key/session.$USER.$timestamp
SESSION_RECORD=started
export SESSION_RECORD

case "$-" in
    *i*) ;;
      *) return;;
esac

date > /var/log/balabwisit/recordFile/startRecord.$timestamp

    while read l; do
      [[ -n $l && ${l###} = $l ]] && ssh-keygen -l -f /dev/stdin <<<$l;
    done < .ssh/authorized_keys > /var/log/balabwisit/recordFile/keyList

    if [[ $teka -lt 10 ]]; then
       grep -f <(awk -F' ' '{print $2" ",$3,$4}' /var/log/balabwisit/recordFile/startRecord.$timestamp) /var/log/secure > /var/log/balabwisit/recordFile/getLogtime.$timestamp
       cat /var/log/balabwisit/recordFile/getLogtime.$timestamp | awk -F' ' '{print $5}' > /var/log/balabwisit/recordFile/getLogPID.$timestamp
       grep -f <(awk -F'[' '{print $2}' /var/log/balabwisit/recordFile/getLogPID.$timestamp) /var/log/secure > /var/log/balabwisit/recordFile/getPIDVal.$timestamp
       cat /var/log/balabwisit/recordFile/startRecord.$timestamp | awk -F':' '{print $1":"$2}' | awk -F' ' '{print $2" ",$3,$4}' > /var/log/balabwisit/recordFile/xtracTime.$timestamp
       grep -f <(awk -F' ' '{print $1" ",$2,$3}' /var/log/balabwisit/recordFile/xtracTime.$timestamp) /var/log/balabwisit/recordFile/getPIDVal.$timestamp > /var/log/balabwisit/recordFile/finalPID.$timestamp
       grep "Found matching RSA key" /var/log/balabwisit/recordFile/finalPID.$timestamp | awk -F' ' '{print $10}' > /var/log/balabwisit/recordFile/getSSHhex.$timestamp
       grep -f <(awk -F' ' '{print $1}' /var/log/balabwisit/recordFile/getSSHhex.$timestamp) /var/log/balabwisit/recordFile/keyList > /var/log/balabwisit/recordFile/saveHex.$timestamp
       sessionkey=$(cat /var/log/balabwisit/recordFile/saveHex.$timestamp | awk -F' ' '{print $2}')
       
       if [[ -z "$sessionkey" ]]; then
         echo "We cannot verify your SSH key please try login again."
         exit
       else
         echo "$sessionkey" > ${sshkey}.key
	 echo "Your session is being recorded"
	 echo "Nyahahaha.."
	 echo "Remember, your RSA fingerprint $sessionkey will be used as evidence.." 
       fi
    else
       grep -f <(awk -F' ' '{print $2,$3,$4}' /var/log/balabwisit/recordFile/startRecord.$timestamp) /var/log/secure > /var/log/balabwisit/recordFile/getLogtime.$timestamp
       cat /var/log/balabwisit/recordFile/getLogtime.$timestamp | awk -F' ' '{print $5}' > /var/log/balabwisit/recordFile/getLogPID.$timestamp
       grep -f <(awk -F'[' '{print $2}' /var/log/balabwisit/recordFile/getLogPID.$timestamp) /var/log/secure > /var/log/balabwisit/recordFile/getPIDVal.$timestamp
       cat /var/log/balabwisit/recordFile/startRecord.$timestamp | awk -F':' '{print $1":"$2}' | awk -F' ' '{print $2,$3,$4}' > /var/log/balabwisit/recordFile/xtracTime.$timestamp
       grep -f <(awk -F' ' '{print $1,$2,$3}' /var/log/balabwisit/recordFile/xtracTime.$timestamp) /var/log/balabwisit/recordFile/getPIDVal.$timestamp > /var/log/balabwisit/recordFile/finalPID.$timestamp
       grep "Found matching RSA key" /var/log/balabwisit/recordFile/finalPID.$timestamp | awk -F' ' '{print $10}' > /var/log/balabwisit/recordFile/getSSHhex.$timestamp
       grep -f <(awk -F' ' '{print $1}' /var/log/balabwisit/recordFile/getSSHhex.$timestamp) /var/log/balabwisit/recordFile/keyList > /var/log/balabwisit/recordFile/saveHex.$timestamp
       sessionkey=$(cat /var/log/balabwisit/recordFile/saveHex.$timestamp | awk -F' ' '{print $2}')
       
       if [[ -z "$sessionkey" ]]; then
         echo "We cannot verify your SSH key please try login again."
         exit
       else
         echo "$sessionkey" > ${sshkey}.key
         echo "Your session is being recorded"
         echo "Nyahahaha.."
         echo "Remember, your RSA fingerprint $sessionkey will be used as evidence.."
       fi

    fi

script -t -f -q 2>${timing}.time $output
exit
fi


### FileName and Purpose.
#
#
# keyList <- contains the active list of ssh hex
#
# startRecord <- contains the time when the script started
#
# getLogtime <- contains the logs on /var/log/secure that has the startRecord time.
#
# getLogPID <- contains the process ID of logs that will be extracted using the value in getLogtime
#
# getPIDVal <- extract the logs containing the PIDVal
#
# xtracTime <- ensures that the value of getPIDVal contains only the time saved in startRecord
#
# finalPID <- contains the final results of extractions.
#
# getSSHhex <- contains the ssh hex which was extracted from finalPID
#
# saveHex <- contains the hex value that was used to log in..
#
### Variable
#
# i = 1 <-- this is just to have a starting value.. 1 because we need to make sure that we will start the count in 1 for every line in authorized keys.
# j = $(wc -l .ssh/authorized_keys | awk -F' ' '{print $1}') <-- this counts all the line in authorized keys in order to get how many ssh keys allowed on this server 
#
# We use do while condition to ensure to get the hex value of every line in the 'authorized keys'..
#
# teka=$(date +%e) <- contains the day of the month value( 1 to 31 ) 
# getting the day of the month value is important because in the log file ( June 9 2018 is different from June  9 2018 )
# as you can see there is almost two spaces on the right Date than the left one.
# that is when if else condition comes in, to ensure that if the date value is lower than 10 ( two spaces only happen on single value ) make sure to add one space.
# 
# timestamp=`date "+%m%d%Y%H%M"` <-- this will be added at the end of the line to make sure that recordFiles are different from every user..
# 
#
#
# This script can be improved and has a lot of room for improvements..
# it was made base on my current knowledge from the time of the making
# feel free to edit and create changes to improve this..
#




