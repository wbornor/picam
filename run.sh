#!/bin/bash

TARGET=s3://picam-private/
DATE=$(date +"%Y-%m-%d_%H%M")

which pip
if [ $? -ne 0 ]; then
  sudo apt-get install python-pip -y
fi

which aws
if [ $? -ne 0 ]; then 
  pip install --user boto
  sudo pip install awscli
fi

which fswebcam
if [ $? -ne 0 ]; then
  sudo apt-get install fswebcam
fi

if [ -z /tmp/picam ]; then
  mkdir /tmp/picam
fi 

IMGFILE=/tmp/picam/picam.$DATE.jpg

fswebcam -r 1290x720 --no-banner $IMGFILE
if [ -z $IMGFILE ]; then
  aws s3 cp $IMGFILE $TARGET
  rm $IMGFILE
fi

exit
