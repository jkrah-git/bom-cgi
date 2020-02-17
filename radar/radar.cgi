#!/bin/bash
# echo "Content-type: text/html"
# echo ""

### ------
get_file()
{
	#cat `dirname $0`/../../../www/IDR403.gif
	curl -s  http://www.bom.gov.au/radar/IDR403.gif 
}
### ------
list_args()
{
	for A in `echo $QUERY_STRING | sed -e 's/\&/ /g'`; do
		echo $A
	done
}
### ------
get_arg()
{
	[ -z "$1" ] || list_args |grep "^$1=" | awk -F= '{ print $2 }'
}


### ------

echo "Content-type: image/gif"
echo ""

let PX=228
let PY=153


## ./conv  -35.157555 149.346770
[ -z "$QUERY_STRING" ] && DEBUG="$1"


# TEXT="$QUERY_STRING"

let ARGC=0
[ -z "$QUERY_STRING" ] && QUERY_STRING="`echo $* | sed -e 's| |\&|g'`"
[ -z "$QUERY_STRING" ] || let ARGC=`echo $QUERY_STRING | awk -F\& '{ print NF }'`
TEXT="[$ARGC]"

if [ ! -z "$DEBUG" ]; then
	list_args
	X0=`get_arg X0`
	echo "X0=[$X0]"
	exit
fi

if [ $ARGC -gt 0 ]; then

	COOD0="-34.809353 148.333878 43 78"
	COOD1="-36.4428 150.061198 358 429"

	COOD2X="`echo $QUERY_STRING |  awk -F\& '{ print $1 }'`"
	COOD2Y="`echo $QUERY_STRING |  awk -F\& '{ print $2 }'`"
	
	

	TEXT="$TEXT MAP[$COOD2X, $COOD2Y]"
	CONV="`dirname $0`/conv"
	RES="`$CONV $COOD0 $COOD1 $COOD2X $COOD2Y`"
	TEXT="$TEXT CONV[$COOD0 $COOD1 $COOD2X $COOD2Y] RES[$RES]"
	if [ `echo $RES | awk -F, '{ print NF }'` -gt 1 ]; then
		let PX=`echo $RES | awk -F, '{ print int($1) }'`
		let PY=`echo $RES | awk -F, '{ print int($2) }'`
		TEXT="$TEXT C[$PX,$PY]"
	fi
fi



let CROPX=200
let CROPY=200
let CROSS=7

let PX1=$PX-$CROSS
let PX2=$PX+$CROSS
let PY1=$PY-$CROSS
let PY2=$PY+$CROSS

let CROPX2=$CROPX/2
let CROPY2=$CROPY/2
let CX=$PX-$CROPX2
let CY=$PY-$CROPY2

let PX3=$PX+18
let PX4=$PX3+18
let PX5=$PX4+18
CROP="-crop ${CROPX}x${CROPY}+$CX+$CY!" 



[ -z "$DEBUG" ] || echo "TEXT=[$TEXT]"
[ -z "$DEBUG" ] && get_file | convert -  \
-fill "#00000000" \
-stroke "#000000ff" \
-draw "line $PX1,$PY $PX2,$PY" \
-draw "line $PX,$PY1 $PX,$PY2" \
-draw "circle $PX,$PY $PX3,$PY" \
-stroke "#0000007f" \
-draw "circle $PX,$PY $PX4,$PY" \
-stroke "#0000002f" \
-draw "circle $PX,$PY $PX5,$PY" \
$CROP -resize 500x500 \
-stroke "#ffffffff" \
-fill "#ffffffff" \
-draw "text 0,10 \"$TEXT\"" \
-


