#!/bin/bash
abort()
{
	echo "$0: ERR [$*]"
	exit 1
}

xmlgetnext () {
   local IFS='>'
   read -d '<' TAG VALUE
}


	RSS=/tmp/canberra.weather.com.au.rss
	[ -f "$RSS" ] || abort "RSS no file [$RSS]"

	let AGE=`date +%s`-`date -r $RSS +%s`
	[ $AGE -gt 1000 ] && abort "file to old [$AGE] secs"


	echo "<PRE>"
	grep w:forecast /tmp/canberra.weather.com.au.rss | sed -e 's|.* day="\(.*\)" description="\(.*\)" min="\(.*\)" max="\(.*\)" icon=.*|\1: \2 (\3 to \4)|g'
	echo "<\PRE>"

	cat $RSS | while xmlgetnext ; do
	echo "$TAG" | grep 'w:current'
   case $TAG in

      'w:current')
	echo "$VALUE"
	;;
      'item')
         TITLE=''
         LINK=''
         DATE=''
         DESC=''
         ;;
      'title')
         TITLE="$VALUE"
         ;;
      'link')
         LINK="$VALUE"
         ;;
      'pubDate')
         # convert pubDate format for <time datetime="">
         DATE1=$( date --date "$VALUE" --iso-8601=minutes )
         DATE2=$( date --date "$VALUE" '+%D %H:%M%P' )
         ;;
      'description')
         DESC="$VALUE"
         ;;
      '/item')
	continue
         cat<<EOF
<article>
<h3><a href="$link">$TITLE</a></h3>
<p>$DESC
<span class="post-date">posted on <time datetime="$DATE1">$DATE2</time></span>
</p>
</article>
EOF
         ;;
      esac
done
## ---------------------
	echo "<PRE>[$AGE] seconds</PRE>"
