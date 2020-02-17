#!/bin/bash
. `dirname $0`/inc/dash_inc.sh || exit 1
echo "Content-type: text/html"
echo ""

###
#### ----------------------------------- MAIN -----------------------------------
header "HomeDashboard"
echo '<TABLE WIDTH="100%">'

	#################
	echo "</TR><TR>"
	SHOWDATE='<iframe src="http://free.timeanddate.com/clock/i74k210t/n57/tlau/fn3/fs32/tcbbb/bas2/bat4/bac666/pa8/tt0/tw1/th1/ta1/tb4" frameborder="0" width="384" height="96"></iframe>'
#	cell "`weather_forecast2`"
#	cell "$SHOWDATE"
#	cell "`weather_cam``weather_cam 11550`"
	echo "<TD COLSPAN=2><CENTER>"
	weather_forecast2
	echo "</TD>"
	cell "$SHOWDATE"

#	cell "`weather_cam``weather_cam 11550`"
	#################
	echo "</TR><TR>"
	# 128km radar
	cell "`bom_img IDR403`"

	# 128k Wind/Doppler
	#cell "`bom_img IDR40I`"
	#cell "`imgurl http://www.shopsmart.au.nu/cgi-bin/go.cgi \"\" 400`"
	#cell "`imgurl 'http://www.shopsmart.au.nu/cgi-bin/dash/radar/radar2.cgi?X0=-35.663&Y0=149.511&A0=261&B0=261&X1=-35.3042&Y1=149.1903&A1=203&B1=182&X2=-35.157555&Y2=149.346770' 'http://www.shopsmart.au.nu/cgi-bin/dash/radar.cgi' 400`"
	cell "`imgurl 'http://www.shopsmart.au.nu/cgi-bin/dash/radar/radar2.cgi?X0=-35.663&Y0=149.511&A0=255&B0=255&X1=-35.3042&Y1=149.1903&A1=197&B1=176&X2=-35.157555&Y2=149.346770' 'http://www.shopsmart.au.nu/cgi-bin/dash/radar.cgi' 400`"

	# 256k
	#cell "`bom_img IDR402`"
	cell "`abc_news`"

	#################
	echo "</TR><TR>"
	# 12h = 43200 sec
	# bom(act) temp,wind,gust
	cell "`cacti 49 8,3,4 43200`"

	let H=`/bin/date +%H`
	if [ $H -gt 6 ] && [ $H -lt 20 ]; then
		# solar pv1,pv2
		cell "`cacti 552 2,3 43200`"
	else
		# bom(moruya) temp,wind,gust
		cell "`cacti 48 8,3,4 43200`"
	fi
	cell "`weather_cam 11747``weather_cam 11550`"
	#cell "`imgurl http://www.shopsmart.au.nu/cgi-bin/go.cgi``weather_cam 11550`"

	#################
	echo "</TR><TR>"
	cell "`cacti 562 2,3 6030`"
	cell "`cacti 568 2,3 6030`"
	# 1 week = 604800 sec
	#internode perc,days 604800
	cell "`cacti 560 4,5 86400`"
	
	#################
	echo "</TR><TR>"
echo "</TABLE>"
footer
