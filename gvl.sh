#!/bin/zsh

# Setting quality value
if [[ $# = 1 ]] then
  QUALITY=$1
else
  echo "Usage: $0 [quality]"
  return 1
fi

# Setting the number of the field
if [[ $QUALITY = "240" ]] then
  FIELD_NUM=2
elif [[ $QUALITY = "360" ]] then
  FIELD_NUM=4
elif [[ $QUALITY = "480" ]] then
  FIELD_NUM=6
elif [[ $QUALITY = "720" ]] then
  FIELD_NUM=8
else 
  echo "Invalid quality value"
  return 1
fi

# Getting the link refers to the video page:
read CODE
echo $CODE | cut -d "\"" -f 2 | read LINK

# Test line
#echo $LINK

# Getting the straight links:
GOT_CODE=$(exec curl -s "$LINK")
USEFUL_CODE=$(echo $GOT_CODE | grep "url240" | head -n 1 | sed "s/.*url240/url240/")
RESULT=$(echo $USEFUL_CODE | cut -d "=" -f $FIELD_NUM | cut -d "?" -f 1 | sed "s/https:/http:/")

# Test line
#echo $RESULT

if ! [[ x$RESULT = x ]] && [[ x`echo $RESULT | grep ".mp4" | grep "$QUALITY"` = x$RESULT ]] then
  echo $RESULT
  return 0
elif ! [[ x$RESULT = x ]] then
  echo "Nonexistent video quality $QUALITY" #stderr
  return 1
else
  echo "Connection error"
  return 1
fi
