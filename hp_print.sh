#!/usr/bin/bash

PORT=$1   ## GPIB to Serial adapter port
DEV=$2    ## GPIB Remote Device

if [ -z "$DEV" ]; then
    echo "USAGE:"
    echo "$0 <serial port> <gpib device>"
    exit
fi

cESC=`echo -e "\033"`

stty -F $PORT 115200 -icrnl -imaxbel -opost \
     -onlcr -isig -icanon -echo min 100 time 2

echo -ne "++addr $DEV\r" > $PORT
echo -ne "++auto 0\r" > $PORT

echo -ne "PRN\r" > $PORT
echo -ne "++read eoi\r" > $PORT
echo -ne "++read eoi\r" > $PORT

#echo "When the EOF marker appears, press Ctrl-C to end"
head -n24 $PORT | sed "s/$cESC&d.//g"
