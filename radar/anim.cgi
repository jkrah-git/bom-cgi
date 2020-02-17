#!/bin/bash
. `dirname $0`/radar-inc.sh || exit 1
### ------

#####################
gettag()
{
	RES="-"
	let C=$1
	[ $(($C % 5)) -eq 0 ] && RES="="
	echo $RES
}
#####################
       OUTPUT="`dirname $0`/../../../www/rad.anim.gif"
	[ -z "$1" ] && let MAX=1
	[ -z "$1" ] || let MAX=$1
        [ $MAX -gt 0 ] || let MAX=1
        let M1=$MAX-1
        let M2=$MAX-2
	let TPW=10
        let TPX=$MAX*$TPW
	let TPY=500

        [ -z "DEBUG" ] || echo "MAX=[$MAX]"
        [ -z "DEBUG" ] || echo ".. newfile[`gettag $M1`]"
        `dirname $0`/render.cgi "T=$M1" | convert - \
-delay 100 \
-stroke "#000000ff"  -fill "#ffffffff"  -draw "text $TPX,$TPY \"`gettag $M1`\"" \
$OUTPUT
	let TPX=$TPX-$TPW
        for F in `seq $M2 -1 0` 0; do
                [ -z "DEBUG" ] || echo ".. frame[`gettag $F`]"
                `dirname $0`/render.cgi "T=$F" | convert \
-delay 20 \
$OUTPUT \
- \
-stroke "#000000ff"  -fill "#ffffffff"  -draw "text $TPX,$TPY \"`gettag $F`\"" \
-layers coalesce \
-layers optimize \
-loop 0 \
$OUTPUT
	[ $F -gt 0 ] && let TPX=$TPX-$TPW
        done
echo "output = [$OUTPUT]"
