#!/bin/bash

LAST_FILE=.danstonchat_last
BASE_URL=http://danstonchat.com

if [ ! -e $LAST_FILE ]
then
    CURRENT=$(wget -O - -q $BASE_URL | grep 'widget_latest_items' | sed -r "s%.*$BASE_URL/([0-9]+).html.*%\1%")
    echo $CURRENT > $LAST_FILE
    echo "$LAST_FILE initialized with id $CURRENT"
    echo
else
    LAST=$(cat $LAST_FILE)
    CURRENT=$(($LAST+1))
fi

HTML=$(wget -O - -q $BASE_URL/$CURRENT.html)
if [ $? -eq 0 ]
then
    echo $CURRENT > $LAST_FILE
    CURRENT_TEXT="$(echo "$HTML" | grep 'item-entry' | sed -r "s/^.*<a href=\".*$CURRENT.html\">//" | sed -r 's/<\/a>.*$//' | sed -r 's/<br ?\/>/\n/g' | sed -r 's/<[^>]*>//g' | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;')"
    echo "$CURRENT_TEXT"
else
    echo ""
fi


