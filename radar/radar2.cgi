#!/bin/bash
. `dirname $0`/radar-inc.sh || exit 1
### ------
get_file()
{
	ARG="$1"

	if [ "$ARG" = "anim" ]; then
		OUTPUT="`dirname $0`/../../../www/rad.anim.gif"
		cat $OUTPUT
		return $?
	else
		ID="`echo $ARG | egrep '^[0-9]*$'`"
		`dirname $0`/render.cgi "T=$1"
		#[ "$ARG" = "file" ] && cat `dirname $0`/../../../www/IDR403.gif
		#[ -z "$ID" ] && curl -s  http://www.bom.gov.au/radar/IDR403.gif 
		## else call out and render full (past) frame
	
		#[ -z "$ID" ] && curl -s http://www.shopsmart.au.nu/cgi-bin/dash/radar/render.cgi
		#[ -z "$ID" ] || curl -s http://www.shopsmart.au.nu/cgi-bin/dash/radar/render.cgi?T=$ID

	fi
}
### ------
### ------
#  "Content-type: text/html"
[ -z "$QUERY_STRING" ] && QUERY_STRING="`echo $* | sed -e 's| |\&|g'`"

##  -------- Main --------
	let ARGC=`echo $QUERY_STRING | awk -F\& '{ print NF }'`
	DEBUG=`get_arg DEBUG`
	NOCROP=`get_arg NOCROP`
	X0=`get_arg X0`
	Y0=`get_arg Y0`
	A0=`get_arg A0`
	B0=`get_arg B0`

	X1=`get_arg X1`
	Y1=`get_arg Y1`
	A1=`get_arg A1`
	B1=`get_arg B1`

	X2=`get_arg X2`
	Y2=`get_arg Y2`
	let NUM=`get_arg NUM`

if [ ! -z "$DEBUG" ]; then
	printf "Content-type: text/plain\n\n"
	echo "QUERY_STRING=[$QUERY_STRING]"
	list_args
	echo "-------"
	echo "DEBUG=[$DEBUG] ARGC=[$ARGC]"
	echo "XY0[$X0,$Y0]/AB0[$A0,$B0]"
	echo "XY1[$X1,$Y1]/AB1[$A1,$B1]"
	echo "XY2[$X2,$Y2].."
	echo "NUM[$NUM].."
else 
	[ -z "$1" ] && printf "Content-type: image/gif\n\n"
fi

	CONV="`dirname $0`/conv"
	RES="`$CONV $X0 $Y0 $A0 $B0 $X1 $Y1 $A1 $B1 $X2 $Y2`"
	#TEXT="CONV[$X0 $Y0 $A0 $B0 $X1 $Y1 $A1 $B1 $X2 $Y2] RES[$RES]"
	if [ `echo $RES | awk -F, '{ print NF }'` -gt 1 ]; then
		let PX=`echo $RES | awk -F, '{ print int($1) }'`
		let PY=`echo $RES | awk -F, '{ print int($2) }'`
		TEXT="C[$PX,$PY]"
	fi

[ -z "$DEBUG" ] || echo "TEXT=[$TEXT]"
## PX,PY 


let CROPX=200
let CROPY=200
let CROPX2=$CROPX/2
let CROPY2=$CROPY/2
let CX=$PX-$CROPX2
let CY=$PY-$CROPY2

#### ----------------- #### -----------------
[ -z "$NOCROP" ] && CROP="-crop ${CROPX}x${CROPY}+$CX+$CY!" 
[ -z "$NOCROP" ] || LINE0=(-stroke '#000000ff' -draw "line $A0,$B0 $A1,$B1")

#### -----------------

crossargs $PX $PY 9
CROSS1=("${CROSS[@]}")

if [ ! -z "$NOCROP" ]; then
crossargs $A0 $B0 9
CROSS2=("${CROSS[@]}")

crossargs $A1 $B1 9
CROSS3=("${CROSS[@]}")
fi

[ -z "$NOCROP" ] && circleargs $PX $PY 18
[ -z "$NUM" ]  || TEXT="[-${NUM}] $TEXT"
##----------------
[ -z "$DEBUG" ] || echo "TEXT=[$TEXT] NUM=[$NUM]"
[ -z "$DEBUG" ] && `dirname $0`/render.cgi T=$NUM | convert - \
"${CROSS1[@]}" \
"${CROSS2[@]}" \
"${CROSS3[@]}" \
"${CIRCLE[@]}" \
"${LINE0[@]}" \
$CROP \
-resize 500x500 \
-stroke "#ffffffff" \
-fill "#ffffffff" \
-draw "text 0,10 \"$TEXT\"" \
-


