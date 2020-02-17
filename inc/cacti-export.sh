#!/bin/bash

for A in $*; do
	[ -z "$ARGS" ] || ARGS="${ARGS} \"|\" \$$A"
	[ -z "$ARGS" ] && ARGS="\$$A"
done
# echo "ARGS=[$ARGS]"
AWKARGS="{ print $ARGS }"

let NOW=`date +%s`

STEP=0
while read LINE; do
	
	if [ "$LINE" = '""' ]; then
		STEP=1
		continue
	fi

	if [ "$STEP" = "1" ]; then
		#echo $LINE | awk -F, "$AWKARGS" 
		echo -n "(age)|"
		echo $LINE | awk -F, "$AWKARGS" | sed 's/"//g'
		STEP=2
		continue
	fi
	if [ "$STEP" = "2" ]; then
		TIMESTAMP="`echo $LINE | awk -F, '{ print $1 }' | sed -e 's/"//g'`"
		let SEC=`/bin/date -d "$TIMESTAMP" +%s`
		TIME="`/bin/date -d "$TIMESTAMP" +%r`"
		let AGE=$NOW-$SEC
		let AGE=$AGE/60
		#echo "NOW=[$NOW], TIMESTAMP=[$TIMESTAMP] SEC=[$SEC]"
		printf "${TIME} <I>(-%.2d mins)</I>|" $AGE
	#	echo -n "${TIME}(-$AGE mins)|"
		for V in `echo $LINE | awk -F, "$AWKARGS" |  sed -e 's/|/ /g; s/"//g'`; do
			printf "%.2f|" $V
		done | sed 's/|$//g'
		echo
		continue
	fi

done 
