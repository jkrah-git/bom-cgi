#!/bin/bash
. `dirname $0`/inc/dash_inc.sh || exit 1
## ----------
radar()
{
	BASE="http://www.shopsmart.au.nu/cgi-bin/dash/radar/radar2.cgi"
	L0="$1"
	L1="$2"
	L2="$3"
	FRAME="$4"

	N0="`echo $L0 | awk -F, '{ print $1 }'`"
	A0="`echo $L0 | awk -F, '{ print $2 }'`"
	B0="`echo $L0 | awk -F, '{ print $3 }'`"
	X0="`echo $L0 | awk -F, '{ print $4 }'`"
	Y0="`echo $L0 | awk -F, '{ print $5 }'`"

	N1="`echo $L1 | awk -F, '{ print $1 }'`"
	A1="`echo $L1 | awk -F, '{ print $2 }'`"
	B1="`echo $L1 | awk -F, '{ print $3 }'`"
	X1="`echo $L1 | awk -F, '{ print $4 }'`"
	Y1="`echo $L1 | awk -F, '{ print $5 }'`"

	N2="`echo $L2 | awk -F, '{ print $1 }'`"
	X2="`echo $L2 | awk -F, '{ print $4 }'`"
	Y2="`echo $L2 | awk -F, '{ print $5 }'`"

	URL="X0=${X0}&Y0=${Y0}&A0=${A0}&B0=${B0}"
 URL="${URL}&X1=${X1}&Y1=${Y1}&A1=${A1}&B1=${B1}"
 URL="${URL}&X2=${X2}&Y2=${Y2}&NOCROP=y"
	if [ ! -z "$FRAME" ]; then
		curl -s "${URL}&FRAME=${FRAME}"
		return 0
	fi

CONV="`dirname $0`/radar/conv"
RES="`$CONV $X0 $Y0 $A0 $B0 $X1 $Y1 $A1 $B1 $X2 $Y2`"


cat << EOpre
<PRE>
(0)($N0) MAP($X0,$Y0) GIF($A0,$B0)
(1)($N1) MAP($X1,$Y1) GIF($A1,$B1)
(X)($N2) MAP($X2,$Y2) RES[$RES]
</PRE>
EOpre
	echo "<img src=\"${BASE}?${URL}\" width=\"500\">"
}
## ----------
echo "Content-type: text/html"
echo ""

#   CROSS=(-stroke '#000000ff' -draw "line $X1,$Y $X2,$Y" -draw "line $X,$Y1 $X,$Y2")


LOC0="Radar,255,255,-35.663,149.511"
LOC1="Bungendore,250,170,-35.2500,149.4500"
LOC2="Airport,197,176,-35.3042,149.1903"
LOC3="Jugiong,43,77,-34.809353,148.333878"
LOC4="Bermagui,361,431,-36.4428,150.061198"
LOC5="Kiama,505,42,-34.673820,150.844376"
#LOC6="mt.kosioski,40,438,-36.4536,148.2580"
LOC6="mt.kosioski,40,438,-36.455700,148.263573"
LOC7="Gundaroo,226,120,-35.0333332,149.2833322"
LOC8="Cooma,191,388,-36.2269,149.1298"
LOC9="Holt,171,166,-35.222626,149.018036"
LOC10="Bradwood,100,100,-35.4333316,149.7999968"
HOME="Home,,,-35.157555,149.346770"
###
#### ----------------------------------- MAIN -----------------------------------
header "Radar"
echo '<TABLE WIDTH="100%">'
        #################
	radar "$LOC0" "$LOC2" "$HOME"
	radar "$LOC0" "$LOC2" "$LOC1"
	radar "$LOC0" "$LOC2" "$LOC3"
	radar "$LOC0" "$LOC2" "$LOC4"
	radar "$LOC0" "$LOC2" "$LOC5"
	radar "$LOC0" "$LOC2" "$LOC6"
	radar "$LOC0" "$LOC2" "$LOC8"
	radar "$LOC0" "$LOC2" "$LOC9"
	radar "$LOC0" "$LOC2" "$LOC10"
	exit
	radar "$LOC0" "$LOC2" "$HOME"
	radar "$LOC0" "$LOC2" "$LOC1"
	radar "$LOC0" "$LOC2" "$LOC7"
	radar "$LOC0" "$LOC2" "$LOC9"
	radar "$LOC0" "$LOC2" "$LOC10"
