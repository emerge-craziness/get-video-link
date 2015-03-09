#!/bin/zsh

echo -n "Link: " 1>&2
read LINK
#echo -n "Where to save: " 1>&2
PLACE=$1
#exec curl -C - -# $LINK -o $PLACE || 
while ! curl -C - -# $LINK -o $PLACE; do
  true
done
