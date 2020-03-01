#!/bin/bash
. `dirname $0`/radar-inc.sh || exit 1
### ------

### ------
#[ -z "$1" ] && printf "Content-type: image/gif\n\n"

#[ -z "$QUERY_STRING" ] || printf "Content-type: image/gif\n\n"
[ -z "$QUERY_STRING" ] && QUERY_STRING="`echo $* | sed -e 's| |\&|g'`"
let ARGC=`echo $QUERY_STRING | awk -F\& '{ print NF }'`

	TEXT="[$ARGC]"
	DEBUG=`get_arg DEBUG`
	FRAME=`get_arg T`


if [ ! -z "$DEBUG" ]; then
[ -z "$1" ] && printf "Content-type: text/plain\n\n"
	#list_args
	#echo "-------"
	echo "DEBUG=[$DEBUG] ARGC=[$ARGC] TS=[`get_radar_ts $NUM`]"
	echo "FRAME[$FRAME].."
fi


[ -z "$1" ] && printf "Content-type: image/gif\n\n"
[ -z "$FRAME" ] && FRAME=0
TEXT="[-$FRAME]"
[ -z "$DEBUG" ] || get_radar "$FRAME"
[ -z "$DEBUG" ] && get_radar "$FRAME" | convert \
`dirname $0`/data/IDR403.background.png \
`dirname $0`/data/IDR403.topography.png \
`dirname $0`/data/IDR403.waterways.png \
`dirname $0`/data/IDR403.roads.png \
`dirname $0`/data/IDR403.range.png \
- \
`dirname $0`/data/IDR403.locations.png \
-layers flatten \
-
##----------------
