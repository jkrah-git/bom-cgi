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
cd ../../.. || abort 'cd err'

ls "$SUBDIR/$FILE" || abort "download faied"
tail -100 "$LOCK" > "$INDEX" || abort "index update failed"
cd ..

`dirname $0`/anim.cgi 10

[ -f "$LOCK" ] && /bin/rm "$LOCK"

