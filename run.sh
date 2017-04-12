#!/bin/bash
set -x

TARGET=s3://picam-private/
DATE=$(date +"%Y-%m-%d_%H%M")

which pip
if [ $? -ne 0 ]; then
  sudo apt-get install python-pip -y
fi

if [ ! -e /usr/local/bin/aws ]; then 
  pip install --user boto
  sudo pip install awscli
fi

which fswebcam
if [ $? -ne 0 ]; then
  sudo apt-get install fswebcam
fi

if [ ! -d /tmp/picam ]; then
  mkdir /tmp/picam
fi 

IMGFILE=/tmp/picam/picam.$DATE.jpg

fswebcam -r 1290x720 --no-banner $IMGFILE
if [ -e $IMGFILE ]; then
  /usr/local/bin/aws s3 cp $IMGFILE $TARGET
  rm $IMGFILE
fi

exit
