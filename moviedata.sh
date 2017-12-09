#!/bin/sh 

#Enter the movie name, and get the suitable results
#Result obtained from IMDB
#------------------------------
murl="http://www.imdb.com/find?ref_=nv_sr_fn&q="
mapnd="&s=tt"
imdb="http://www.imdb.com"
#murl+search+apnd
remod="http://www.imdb.com/title/tt"
rapnd="/?ref_=fn_tt_tt_1"
#remod+ID+rapnd
touch /tmp/moviedata.$$
chmod u+rwx /tmp/moviedata.$$
tempout="/tmp/moviedata.$$"
#------------------------------
summary()
{	#film synopsis
declare -a itarray
res1=$( grep '<td class="result_text">' $tempout |sed 's/<\/tr>/\n&/g'| sed 's/>/\n&/g' | grep '</a'| sed 's/<\/a >/\n& /g') 
r2=$( grep '<td class="result_text">' $tempout |sed 's/<\/tr>/\n&/g'| sed 's/>/\n&/g'| grep '<a href=') 
res=$(echo $res1 | sed 's/<\/a >/+/g'| sed 's/ /_/g'| sed 's/+/ /g')
res2=$(echo $r2| sed 's/>//g'|sed 's/<a href=//g'|sed 's/  / /g'|sed 's/"//g')
count=0
mcount=0
count2=-1
str=""
for i in $res;do
	if [ $(($count %2)) -eq 1 ];then		
		for j in $res2;do
			if [ $count2 -eq $mcount ];then
				str=$j
				break
			else
			count2=$(($count2+1))
			fi			
		done
		mcount=$(($mcount+1))		
		echo "$mcount : $i --> Link: $imdb$str "
	fi
count=$(($count+1))
done
exit 0 
}
#------------------------------
summarysingle()
{ #grep "<title>" mememe | sed 's/<title>//; s/<\/title>//;s/- [A-Z]*[a-z]//'
title=$(grep "<title>" $tempout | sed 's/<title>//; s/<\/title>//;s/- [A-Z]*[a-z]//')
summary=$(grep ' <em class="nobr">' $tempout| sed 's/<em class="nobr">Written by//')
echo "Title: $title"
echo "Summary: $summary"
exit 1
}

#------------------------------
trap "rm -f $tempout" 0 1 15

if [ $# -eq 0 ]; then
	echo 'Usage: $0 syntax:"movie title" | movie ID }'
	exit 1
fi

fixedname=$(echo $@ | tr ' ' '+')
#URLs are usually stringed together using +. What, you've never seen a google search tab before !

if [ $# -eq 1 ]; then
	nodigits=$(echo $1 | sed 's/[[:digit:]]*//g')
		#darn zero
	if [ -z "$nodigits" ] ; then
		lynx -source "$remod$fixedname$rapnd" > $tempout
		summarysingle
	fi
fi

url="$murl$fixedname$mapnd"
lynx -source $url > $tempout
if [ -z "$(grep 'No results found' $tempout)" ]; then
summary
else
echo "Movie match not found on IMDB"
fi
exit 0
