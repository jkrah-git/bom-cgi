#!/bin/bash
. `dirname $0`/inc/dash_inc.sh || exit 1
echo "Content-type: text/html"
echo ""

###
#### ----------------------------------- MAIN -----------------------------------
header "Dash2"
echo '<TABLE WIDTH="100%">'

	#################
	echo "</TR><TR>"
	# 1h=3600
	# 2h=7200
	# 12h = 43200 sec
	# Load 1,5,15m
	LT=7260
	cell "`cacti 30 2,3,4 $LT`"
	cell "`cacti 10 2,3,4 $LT`"
	cell "`cacti 511 2,3,4 $LT`"
	echo "</TR><TR>"
	#################
	cell "`cacti 32 2,3,4 $LT`"
	cell "`cacti 12 2,3,4 $LT`"
	cell "`cacti 516 2,3,4 $LT`"
	echo "</TR><TR>"
	#################
	cell "`cacti 562 2,3 $LT`"
	cell "`cacti 568 2,3 $LT`"
	cell "`cacti 86 2,3 $LT`"
	echo "</TR><TR>"
	
	#################
	echo "</TR><TR>"
echo "</TABLE>"
footer
