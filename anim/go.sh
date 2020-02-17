#!/bin/bash

DATADIR="`dirname $0`/data"
ls -ld $DATADIR > /dev/null || exit 1

## http://www.bom.gov.au/radar/IDR403.gif?20200215104431

# http://www.bom.gov.au/radar/IDR403.gif?20200215110835
# Sat Feb 15 11:11:09 UTC 2020
# 2020 0215 110835



getimg()
{
	let N=$1
	let GAP=6*$N

	#THEN=`date -u -d "$D - $GAP mins" "+%Y%m%d%H%M%S"`
	THEN=`date -u -d "$D - $GAP mins"`

	#URL="http://www.bom.gov.au/radar/IDR403.gif?$THEN"
	#URL="http://www.bom.gov.au/radar/IDR403.T.$THEN.png"
	let MIN=$(printf "%d" `date -u -d "$THEN" +%M`)
	let STEP=$MIN/6
	let NEWMIN=$STEP*6
	FINMIN=`printf "%.2d" $NEWMIN`
	TS="`date -u -d \"$THEN\" +%Y%m%d%H`${FINMIN}"
	#URL="http://www.bom.gov.au/radar/IDR403.T.202002151200.png"
	URL="http://www.bom.gov.au/radar/IDR403.T.${TS}.png"

	echo "URL=[$URL]"
	if [ ! -f "$OUTPUT" ]; then
		#curl -s "$URL" > $OUTPUT || exit 1
		cat `dirname $0`/data/IDR403.background.png > $OUTPUT || exit 1

	else
		#curl -s "$URL"  | convert -delay 50 $OUTPUT -layers coalesce - -layers optimize $OUTPUT
		curl -s "$URL"  | convert -delay 50 $OUTPUT -layers coalesce - -layers optimize $OUTPUT
	fi
}

# ftp://ftp.bom.gov.au/anon/gen/radar_transparencies/IDR403.background.png
# data/IDR403.background.png
# data/IDR403.catchments.png
# data/IDR403.locations.png
# data/IDR403.rail.png
# data/IDR403.range.png
# data/IDR403.riverBasins.png
# data/IDR403.roads.png
# data/IDR403.topography.png
# data/IDR403.waterways.png
# data/IDR403.wthrDistricts.png


D=`date -u`
SEQ="`seq 3 -1 0`"
OUTPUT="`dirname $0`/../../../www/rad.anim.gif"
[ -f "$OUTPUT" ] && rm "$OUTPUT"
echo "OUTPUT=[$OUTPUT]"


for I in $SEQ; do
	echo -n "$I.. "
	getimg $I
	#getimg $I | convert -delay 50 $OUTPUT -layers coalesce - -layers optimize $OUTPUT 
done
echo "done.."
