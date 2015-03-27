#!/bin/zsh

# Setting quality value
if [[ $# = 1 ]] || [[ $# = 2 ]]
then
  QUALITY=$1
else
  echo "Usage: $0 <quality> [-x]" #-x flag puts the output to xclip
  return 1
fi

# Setting the number of the field
if [[ $QUALITY = "240" ]] 
then
  FIELD_NUM=2
elif [[ $QUALITY = "360" ]] 
then
  FIELD_NUM=4
elif [[ $QUALITY = "480" ]] 
then
  FIELD_NUM=6
elif [[ $QUALITY = "720" ]] 
then
  FIELD_NUM=8
elif [[ $QUALITY = "max" ]] 
then
  #nothing
else 
  echo "Invalid quality value." 1>&2 #stderr
  echo "It must be in {240,360,480,720,max}" 1>&2 #stderr
  return 1
fi

# Getting the link refers to the video page:
echo -n "Iframe video code: " 1>&2
read CODE
LINK=$(echo $CODE | cut -d "\"" -f 2)

# Test line
#echo $LINK

# Getting the straight links:
GOT_CODE=$(exec curl -s "$LINK")
USEFUL_CODE=$(echo $GOT_CODE | grep --text "url240" | head -n 1 | sed "s/.*url240/url240/" | sed "s/cache.*//" | sed "s/jpg=htt.*//")
if [[ $1 = "max" ]] 
then
  NUM_OF_SEPARATORS=$(echo $USEFUL_CODE | grep -o "=" | wc -l)
  FIELD_NUM=$NUM_OF_SEPARATORS
fi
RESULT=$(echo $USEFUL_CODE | cut -d "=" -f $FIELD_NUM | cut -d "?" -f 1 | sed "s/https:/http:/")



# Test line(s)
#echo "echo USEFUL_CODE | grep -o "=" | wc -l ==== `echo $USEFUL_CODE | grep -o "=" | wc -l`"
#echo "Got_code is $GOT_CODE"
#echo "Useful_code is $USEFUL_CODE"
#echo "Result is $RESULT"
#echo $NUM_OF_SEPARATORS



if ! [[ x$RESULT = x ]] 
then
  if [[ $2 = "-x" ]]
  then
    echo $RESULT | xclip
  else
    echo $RESULT
  fi
  return 0
elif ! [[ x$USEFUL_CODE = x ]] 
then
  echo "Nonexistent video quality $QUALITY." 1>&2 #stderr
  echo "Use \`$0 max\` to get the highest possible quality" 1>&2 #stderr
  return 1
else
  echo "Connection error" 1>&2 #stderr
  return 1
fi
