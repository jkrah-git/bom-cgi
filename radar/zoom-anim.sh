#!/bin/bash
cd `dirname $0`/data || exit
C=$1
[ -z "$C" ] && C=10
FILES="`tail -$C index.txt | sed -e 's/T/zoom/g'`"
LAST="`tail -1 index.txt | sed -e 's/T/zoom/g'`"
convert  -delay 20 -loop 0 $FILES $LAST $LAST $LAST  ../www/zoom.gif
