#!/usr/bin/bash

PORT=$1   ## GPIB to Serial adapter port
DEV=$2    ## GPIB Remote Device
DEST=$3   ## Destination file

if [ -z "$DEST" ]; then
    echo "USAGE:"
    echo "$0 <serial port> <gpib device> <destination filename>"
    exit
fi

stty -F $PORT 115200 -icrnl -imaxbel -opost \
     -onlcr -isig -icanon -echo min 100 time 2

echo -ne "++addr $DEV\r" > $PORT
echo -ne "++auto 0\r" > $PORT

# Set the starting point of the data
echo -ne "DAT:STAR 1\r" > $PORT
# Set the ending point of the data. In this case we use a very large
# number. The scope will clip this to the number of points in the
# acquisition.
echo -ne "DAT:STOP 10000000\r" > $PORT
# Set the depth. Two bytes per sample.
echo -ne "DAT:WID 2\r" > $PORT
# Set the encoding to binary data. In this case, two bytes will be
# sent per sample, as binary data. The most significant byte will be
# transferred first.
echo -ne "DAT:ENC RIB 2\r" > $PORT
# Ask the scope to send across the curve.
echo -ne "CURV?\r" > $PORT
# Begin data transfer.
echo -ne "++read eoi\r" > $PORT

# We are using dd to swap the byte order.
dd conv=swab if=$PORT of=$DEST

# Simple MATLAB Example for reading this data:
### fid = fopen('dump')
### b = fread(fid, Inf, 'int16');
### plot(b)
### fclose(fid);
