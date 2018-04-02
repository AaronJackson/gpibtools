#!/usr/bin/bash

PORT=$1   ## GPIB to Serial adapter port
DEV=$2    ## GPIB Remote Device
DEST=$3   ## Destination file

if [ -z "$DEST" ]; then
    echo "USAGE:"
    echo "$0 <serial port> <gpib device> <destination filename>"
    exit
fi

stty -F $PORT 115200

echo -ne "++addr $DEV\r" > $PORT
echo -ne "++auto 0\r" > $PORT

echo -ne "HARDC:FORM EPSColor\r" > $PORT
echo -ne "HARDC:PORT GPI\r" > $PORT
echo -ne "HARDC STAR\r" > $PORT
echo -ne "++read eoi\r" > $PORT

echo "When the EOF marker appears, press Ctrl-C to end"
cat $PORT | tee $DEST
