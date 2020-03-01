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
	[ -z "$1" ] || list_args |grep "^$1=" | awk -F= '{ print $2 }' | awk '{ print $1 }'
}
#### -----------------

get_radar_ts()
{
	let N=0
	[ -z "$1" ] || let N=$1
        let GAP=6*$N
	D=`date -u`
        THEN=`date -u -d "$D - $GAP mins"`

	let MIN=$(printf "%d" `date -u -d "$THEN" +%-M`)
	let MIN=$MIN-2
	[ $MIN -lt 0 ] && let MIN=$MIN+60
	let IDX=$MIN/6
	let NEWMIN=$IDX*6
	FINMIN=`printf "%.2d" $NEWMIN`
#	TS="`date -u -d \"$THEN\" +%Y%m%d%H`${FINMIN}"
	echo "`date -u -d \"$THEN\" +%Y%m%d%H`${FINMIN}"
}

###
conv_ts()
{
	TS1="$1"
	[ -z "$TS1" ] && TS1="`get_radar_ts`"
	# TS2="2020-03-01 01:42:00"
	TS2="`echo $TS1  | sed 's|^\(....\)\(..\)\(..\)\(..\)\(..\)$|\1-\2-\3 \4:\5:00|g'`"
	# TS3=epoc sec
	TS3=`date -u +%s -d "$TS2"`
	date -d @$TS3 +%a\ %x\ %X
}
#### -----------------
get_radar()
{
	#URL="http://www.bom.gov.au/radar/IDR403.T.202002151200.png"
	#echo $TS
#	TS="`get_radar_ts $*`"
#	URL="http://www.bom.gov.au/radar/IDR403.T.${TS}.png"
#	[ -z "$DEBUG" ] && curl -s "$URL"
#	[ -z "$DEBUG" ] || echo "curl -s \"$URL\"" 


DATADIR="`dirname $0`/data"
cd $DATADIR || abort 'cd err'

TS="`get_radar_ts $*`"
URL="http://www.bom.gov.au/radar"

SUBDIR="`date +%y`/`date +%m`/`date +%d`"
FILE="IDR403.T.${TS}.png"
cd "$SUBDIR" || curl -s "$URL/$FILE"
[ -f "$FILE" ] || curl -s "$URL/$FILE"
[ -f "$FILE" ] && cat $FILE





}

#### -----------------
#### Cross hairs (px,py,size)
crossargs()
{
	let X=$1
	let Y=$2
	let Z=$3
	let CX1=$X-$Z
	let CX2=$X+$Z
	let CY1=$Y-$Z
	let CY2=$Y+$Z
	CROSS=(-stroke '#000000ff' -draw "line $CX1,$Y $CX2,$Y" -draw "line $X,$CY1 $X,$CY2")
}
#### -----------------
#### Circle ARGS
circleargs()
{
	let X=$1
	let Y=$2
	let Z=$3
	let CX1=$X+$Z
	let CX2=$CX1+$Z
	let CX3=$CX2+$Z
CIRCLE=(
-fill '#00000000' \
-stroke "#000000ff" \
-draw "circle $X,$Y $CX1,$Y" \
-stroke "#0000007f" \
-draw "circle $X,$Y $CX2,$Y" \
-stroke "#0000002f" \
-draw "circle $X,$Y $CX3,$Y")
}
#### -----------------
### ------
# crossargs $PX $PY 9
# CROSS1=("${CROSS[@]}")
