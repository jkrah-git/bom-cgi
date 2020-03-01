#!/bin/bash
. `dirname $0`/radar-inc.sh || exit 1
### ------
abort()
{
	echo "$0 abort: $*"
	[ -f "$LOCK" ] && /bin/rm "$LOCK"
	exit 1
}
### ------
### ------ ### ------

LOCK=/tmp/radar.lock

[ -f "$LOCK" ] && abort "lock[$LOCK] found.. (already running)"




DATADIR="`dirname $0`/data"
cd $DATADIR || abort 'cd err'
INDEX="index.txt"
[ -f "$INDEX" ] || touch "$INDEX"
cat "$INDEX" > "$LOCK" || abort "Failed touch[$LOCK]"

TS="`get_radar_ts $*`"
URL="http://www.bom.gov.au/radar"

SUBDIR="`date +%y`/`date +%m`/`date +%d`"
[ -d "$SUBDIR" ] || mkdir -p "$SUBDIR" || abort "mkdir err"
cd "$SUBDIR" || abort "cd err"

FILE="IDR403.T.${TS}.png"


if [ ! -f "$FILE" ]; then
	let TRY=1
	while [ $TRY -le 3 ]; do
		echo "attempt[$TRY][$FILE].."
		wget "$URL/$FILE" && break
		let TRY=$TRY+1
		sleep 10
	done
	[ -f "$FILE" ] && echo "$SUBDIR/$FILE" >> "$LOCK" 
fi 

FILE2="IDR403.zoom.${TS}.png"
wget "http://www.shopsmart.au.nu/cgi-bin/dash/radar/radar2.cgi?X0=-35.663&Y0=149.511&A0=255&B0=255&X1=-35.3042&Y1=149.1903&A1=197&B1=176&X2=-35.157555&Y2=149.346770" -O $FILE2

cd ../../.. || abort 'cd err'

ls "$SUBDIR/$FILE" || abort "download faied"
tail -100 "$LOCK" > "$INDEX" || abort "index update failed"
cd ..

#`dirname $0`/anim.cgi 10
`dirname $0`/zoom-anim.sh 10

[ -f "$LOCK" ] && /bin/rm "$LOCK"

