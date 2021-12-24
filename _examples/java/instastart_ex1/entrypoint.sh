#!/bin/sh
rm -f /tmp/km.sock
echo > /usr/share/kontain/start_time
KM_MGTPIPE=/tmp/km.sock exec /opt/kontain/java/bin/java -XX:-UseCompressedOops -jar /opt/src/app/app.jar