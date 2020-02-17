#!/bin/bash

#### -----------------------------------
header()
{
	cat << EndHead
<HTML><HEAD>
<meta http-equiv="refresh" content="300">


<style>
table {
  font-family: arial, sans-serif;
  font-size: 10px;
  border-collapse: collapse;
}

td, th {
  border: 1px solid #dddddd;
  text-align: center;
  padding: 2px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>

<TITLE>$1</TITLE>
</HEAD>
<BODY>
EndHead
}

#### -----------------------------------
footer()
{
	echo "</BODY> </HTML>"
}

#### -----------------------------------

raw_table()
{
	let C=0
	echo "<TABLE WIDTH=\"100%\">"
	while read LINE; do
		if [ $C -eq 0 ]; then
			# heading row
			echo -n "<TR><TH>"
			echo -n $LINE | sed -s "s:|:</TH><TH>:g"
			echo "</TH></TR>"
		else
			# normal row
			echo -n "<TR><TD>"
			echo -n $LINE | sed -s "s:|:</TD><TD>:g"
			echo "</TD></TR>"
		fi
		let C=$C+1
	done
	echo "</TABLE>"
}
#### -----------------------------------
imgurl()
{
	IMG_URL="$1"
	IMG_LINK="$2"
	WIDTH="$3"
	[ -z "$WIDTH" ] && echo "<a href=\"$IMG_LINK\"><img src=\"${IMG_URL}\"></img></a>"
	[ -z "$WIDTH" ] || echo "<a href=\"$IMG_LINK\"><img src=\"${IMG_URL}\" width=$WIDTH></img></a>"
}

###----------------
cacti()
{
	GID="$1"
	FIELDS="`echo $2 | sed -s 's/,/ /g'`"
	[ -z "$3" ]  || let SPAN="$3"
	
	[ -z "$GID" ] && return 
	[ -z "$SPAN" ] && let SPAN=60*60
	let NOW=`/bin/date +%s`
	let START=$NOW-$SPAN
	WIDTH=320
	HEIGHT=100
	NOLEG="1"

	#echo "<PRE>GID=[$GID]</PRE>"
	CACTI_BASE="http://nagios.shopsmart.au.nu/cacti"
	GRAPH_URL="$CACTI_BASE/graph.php?action=view&local_graph_id=$GID"
	IMG_URL="$CACTI_BASE/graph_image.php?local_graph_id=$GID"
	IMG_ARGS="${IMG_ARGS}&graph_start=$START"
	IMG_ARGS="${IMG_ARGS}&graph_height=$HEIGHT&graph_width=$WIDTH"
	IMG_ARGS="${IMG_ARGS}&graph_nolegend=$NOLEG"
	imgurl "${IMG_URL}${IMG_ARGS}" "$GRAPH_URL"

	let SPAN=1200
	let START=$NOW-$SPAN
	EXPORT_URL="$CACTI_BASE/graph_xport.php?local_graph_id=$GID"
	EXPORT_URL="${EXPORT_URL}&graph_start=$START"
	curl -s "$EXPORT_URL" | `dirname $0`/inc/cacti-export.sh "$FIELDS" | raw_table
	
	#---------------
	#echo "<PRE>$EXPORT_URL</PRE>"
	#echo "<PRE>"
	#echo "FIELDS=[$FIELDS]"
	#echo "</PRE>"
}
#### -----------------------------------
cell()
{
	echo "<TD>$*</TD>"
}
#### -----------------------------------
bom_img()
{
	ID="$1"
	[ -z "$ID" ] && ID="IDR403"
	WIDTH=400
	#HEIGHT=200
	IMG_LINK="http://www.bom.gov.au/products/${ID}.shtml"
	IMG_LINK="http://www.bom.gov.au/products/${ID}.loop.shtml"
	IMG_URL="http://www.bom.gov.au/radar/${ID}.gif"
	echo "<a href=\"$IMG_LINK\"><img src=\"${IMG_URL}\" width=$WIDTH></img></a>"
	#imgurl "http://www.bom.gov.au/radar/${ID}.gif" "http://www.bom.gov.au/products/${ID}.loop.shtml"
}

###
#### -----------------------------------
weather_cam()
{
	ID="$1"
	[ -z "$ID" ] && ID="11747"
	IMG_LINK="https://ozforecast.com.au/cgi-bin/weatherstation.cgi?station=${ID}&animate=6"
	IMG_URL="https://ozforecast.com.au/images/${ID}/${ID}-latest-tiny.jpg"
	#echo "<a href=\"$IMG_LINK\"><img src=\"${IMG_URL}\"></img></a>"
	#imgurl "$IMG_URL" "$IMG_LINK"
	WIDTH=270
	echo "<a href=\"$IMG_LINK\"><img src=\"${IMG_URL}\" width=\"$WIDTH\" border=\"2\" ></img></a>"
}

#### -----------------------------------
weather_forecast()
{
	RSS=/tmp/canberra.weather.com.au.rss
	[ -f "$RSS" ] || abort "RSS no file [$RSS]"

	let AGE=`date +%s`-`date -r $RSS +%s`
	[ $AGE -gt 1000 ] && abort "file to old [$AGE] secs"


	CUR_SED1='.*current temperature="\(.*\)" dewPoint=".*" humidity=".*" windSpeed="\(.*\)" windGusts="\(.*\)" windDirection="\(.*\)" pressure=".*" rain="\(.*\)".*'
	CUR_SED2='Temp: \1 Wind:\2/\3/\4 Rain:\5'
	echo "<H2>"
	grep w:current /tmp/canberra.weather.com.au.rss | sed -e "s~$CUR_SED1~$CUR_SED2~g"
	echo "</H2>"

	#SED='s:.* day="\(.*\)" description="\(.*\)" min="\(.*\)" max="\(.*\)" icon=.* iconUri="\(.*\)" iconAlt=.*:\1 <img src="\5">|\2|\3|\4:g'
	SED1='.* day="\(.*\)" description="\(.*\)" min="\(.*\)" max="\(.*\)" icon=.* iconUri="\(.*\)" iconAlt=.*'
	SED2='\1<BR><img src="\5">|\2|\3|\4'
	
	( 
	  echo "Day|- Forecast -|(min)|(max)" 
	  grep w:forecast /tmp/canberra.weather.com.au.rss | sed -e "s~$SED1~$SED2~g"
	 ) | raw_table
	let MIN=$AGE/60
	echo "<I>(Updated $MIN min. ago)</I><BR>"

}
#### -----------------------------------
weather_forecast2()
{
	echo '<div style="width: 750px;"><iframe style="display: block;" src="https://cdnres.willyweather.com.au/widget/loadView.html?id=56033" width="750" height="92" frameborder="0" scrolling="no"></iframe><a style="float: right;position: relative;width: 20px;text-indent: -9999em;z-index: 1;margin: -92px 0 0 0;height: 92px" href="https://www.willyweather.com.au/nsw/southern-tablelands/bywong.html" rel="nofollow">Bywong weather</a></div>'

}
#### -----------------------------------
abc_news()
{
        echo "<h2>ABC NEWS</h2>"
        echo "<TABLE WIDTH=\"100%\">"
        #echo '<div align="left">'
        `dirname $0`/inc/rss2html.pl '/tmp/www.abc.net.au.news.rss' 20 | while read LINE; do
                TEXT="`echo $LINE | awk -F\| '{ print $1 }'`"
                URL="`echo $LINE | awk -F\| '{ print $2 }'`"
                AGE="`echo $LINE | awk -F\| '{ print $3 }'`"
                echo "<TR><TD>"
        echo '<div align="left">'
                echo "($AGE) <A HREF=\"$URL\">$TEXT</A>"
        echo '</div>'
                #echo "</TD><TD>$AGE</TD></TR>"
        done
        echo "</TABLE>"

}
#### -----------------------------------
#### -----------------------------------




