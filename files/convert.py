#!/usr/bin/python

import os
import sys
import select

## Function to find owner
## This function ensure that the label/name of RSAkey is extracted and save to a file for the usage of next function..

def getOwner():
  fname = '/var/log/balabwisit/log/keyNlist'
  if os.path.isfile(fname):
    with open(fname,'r') as f:
      for line in f:
          sshList,sshKey=line.split(' ')
          sshKey=sshKey.strip('\n')
          command = '/bin/grep -f /var/log/balabwisit/key/'+sshKey+' /var/log/balabwisit/pid/activeKeys >> /var/log/balabwisit/log/keyOwner'
          os.system(command)
          #print(sshKey)
getOwner()

## This functions combines the labe/name of RSAkey plus the date/time when it was generated.
## The result of this will be used as the name for the GIF file/MP4 file

def createFilename():
   command = '/bin/cat /var/log/balabwisit/log/keyOwner | /bin/awk -F\' \' \'{print $2}\' > /var/log/balabwisit/log/ownerName'
   command1 = '/bin/cat /var/log/balabwisit/log/finalList | /bin/awk -F\'.\' \'{print $3}\' > /var/log/balabwisit/log/timeStamp'
   command2 = '/usr/bin/paste -d"." /var/log/balabwisit/log/ownerName /var/log/balabwisit/log/timeStamp > /var/log/balabwisit/log/recordName'
   command3 = '/usr/bin/paste -d" " /var/log/balabwisit/log/finalList /var/log/balabwisit/log/recordName > /var/log/balabwisit/log/fileNaming'

   os.system(command)
   os.system(command1)
   os.system(command2)
   os.system(command3)

createFilename()


## This function will convert the session file that was recorded to a video for later viewing.

def convertToVid():
  fname = '/var/log/balabwisit/log/fileNaming'
  if os.path.isfile(fname):
    with open(fname,'r') as f:
      for line in f:
          sName,kName=line.split(' ')
          kName=kName.strip('\n')
          command = 'cd /var/log/balabwisit/video/congif && ./congif -o /var/log/balabwisit/video/gif/'+kName+'.gif /var/log/balabwisit/time/'+sName+'.time /var/log/balabwisit/session/'+sName
          command2 = 'cd /var/log/balabwisit/video/gif/ && /usr/bin/ffmpeg -f gif -i '+kName+'.gif /var/log/balabwisit/video/mp4/'+kName+'.flv'
          os.system(command)
          os.system(command2)
  else:
    print("it does not exist")

convertToVid()

## This function will remove the GIF file that was used to convert the session file to VID file

#def removeGif():
#  fname = '/var/log/balabwisit/log/fileNaming'
#  if os.path.isfile(fname):
#    with open(fname,'r') as f:
#      for line in f:
#          sName,kName=line.split(' ')
#          kName=kName.strip('\n')
#          command = '/bin/rm -f /var/log/balabwisit/video/gif/'+kName+'.gif'
#          os.system(command)
#  else:
#    print("it does not exist")

#removeGif()


## Function to remove file that has been used already
## To ensure that we will only keep the mp4 file.

#def cleanUp():
#  fname = '/var/log/balabwisit/log/fileNaming'
#  if os.path.isfile(fname):
#    with open(fname,'r') as f:
#      for line in f:
#          sName,kName=line.split(' ')
#          kName=kName.strip('\n')
#          command = '/bin/rm -f /var/log/balabwisit/session/'+sName+' /var/log/balabwisit/time/'+sName+'.time /var/log/balabwisit/log/*'
#          os.system(command)
#  else:
#    print("File does not exist")

#cleanUp()
## Function to remove empty file

#def removeEmpty():
#  fname = '/tmp/balabwisit/video/file/sessionNone'
#  if os.path.isfile(fname):
#    with open(fname,'r') as f:
#      for line in f:
#          ftime,ftype=line.split('.')
#          ftype=ftype.strip('\n')
#          command = 'rm -f /tmp/balabwisit/session_'+ftime+'.logs /tmp/balabwisit/time/time_'+ftime+'.time'
          #print(command)
#          os.system(command)
#  else:
#    print("File do not exist")

#removeEmpty()

