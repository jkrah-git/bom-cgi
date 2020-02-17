#!/bin/bash

getimg()
{
	[ -z "$PROD" ] && return
	let N=$1 || return
	URL="http://www.bom.gov.au/charts_data/${PROD}/current/mslp-precip/${PROD}.mslp-precip"
	URL="`printf 'http://www.bom.gov.au/charts_data/%s/current/mslp-precip/%s.mslp-precip.%.3d.png' $PROD $PROD $N`"
	curl -s "$URL" 
}


PROD="IDY20202"
SEQ="`seq 3 3 24`"
OUTPUT="`dirname $0`/../../../www/$PROD.anim.gif"
getimg 3 > $OUTPUT || exit 

for I in $SEQ; do
	echo -n "$I.. "
	getimg $I | convert -delay 50 $OUTPUT -layers coalesce - -layers optimize $OUTPUT 
done
echo "done.."
