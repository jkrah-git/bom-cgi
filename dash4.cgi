#!/bin/bash
. `dirname $0`/inc/dash_inc.sh || exit 1
echo "Content-type: text/html"
echo ""

###
#### ----------------------------------- MAIN -----------------------------------
header "Dash3"
echo '<TABLE WIDTH="100%">'


	#cell(){echo "<TD>$*</TD>"}
	#################
	echo "</TR><TR>"
	echo "<td rowspan=\"3\">"
	
	IMG_URL="http://www.bom.gov.au/charts_data/IDY20202/current/mslp-precip/IDY20202.mslp-precip.003.png?1581552000"
	IMG_LINK="http://www.bom.gov.au/australia/charts/4day_col.shtml"
	echo "<a href=\"$IMG_LINK\"><img src=\"${IMG_URL}\" height="600"></img></a>"

	echo "</TD>"

	
	#################
	echo "</TR><TR>"
	# 1h=3600
	# 2h=7200
	# 12h = 43200 sec
	# Load 1,5,15m
	LT=7260
	cell "`cacti 30 2,3,4 $LT`"
	cell "`cacti 32 2,3,4 $LT`"
	echo "</TR><TR>"
	#################
	cell "`cacti 10 2,3,4 $LT`"
	#cell "`cacti 32 2,3,4 $LT`"
	cell "`cacti 12 2,3,4 $LT`"
	#cell "`cacti 516 2,3,4 $LT`"
	echo "</TR><TR>"
	#################
	#cell "`cacti 562 2,3 $LT`"
	#cell "`cacti 568 2,3 $LT`"

	cell "`cacti 86 2,3 $LT`"
	cell "`cacti 511 2,3,4 $LT`"
	cell "`cacti 516 2,3,4 $LT`"
	echo "</TR><TR>"
	
	#################
	echo "</TR><TR>"
echo "</TABLE>"
footer
