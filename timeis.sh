#!/bin/sh

zonedr="/usr/share/zoneinfo"
if [ ! -d $zonedr ];then
	echo "Timezone database doesn't exist"; exit 1;
fi

if [ -d "$zonedr/posix"];then
	zonedr="/usr/share/zoneinfo/posix";
fi

if [ $# -eq 0 ];then
	timezone="UTC"
	mixedzone="UTC"
elif [ "$1 " = " list" ];then
	( echo " All known time zones and regions defined on this system : "
	cd $zone dir
	find * - type f -print | xargs - n 2 | \
	awk '{ pr in tf " %-3 8s %- 3 8s\ n " , $ 1 , $ 2 }'
	) | more
	exit 0
else
	region="$(dirname $1)"
	zone="$(basename $1)"

matchcnt =" $(find $zonedir -name $zone - type f -print | wc - l | sed 's/[^[:digit:]] / /g') "

if [ "$matchcnt" -gt 0 ]; then
	if [ $matchcnt -gt 1 ] ; then
		echo " \"$zone\" matches more than one possible time zone record." 
		echo " Please use 'list' to see all known region"
		exit 1
	fi
match="$(find $zonedir -name $zone -type f - print)"
mixedzone="$zone"
else
	mixedregion="$(echo ${region%$ {region#?}} | tr '[[:lower:]]' '[[:upper:]]' )\
	$(echo ${region#?} | tr '[[:upper:]]' '[[:lower:]]') "
	mixedzone="$(echo${zone%${zone#?}} | tr '[[:lower:]]' '[[:upper:]]') \
	$(echo ${zone#?} | tr '[[ :uppe r :]] ' '[[ : l ow er :] ] ') "
	if [ "$mixedregion" != "." ];then
		match= "$( fi nd $ zone dir/$ m ixe d r egi o n - ty pe f -n a me $m ix e dz on e - pr i nt )"
	else
		match= "$( fi nd $ zone dir - n ame $ mix e d zo ne - t yp e f - p ri nt ) "
	fi

	if [ - z "$match" ];then
		if [ ! -z $ (fin d $z onedi r -n a m e $ m i xe dz on e - ty p e d - pr i nt ) ]; then
			echo "The region \"$1\" has more than one time zone . Please use 'list'"
		else
			echo "No exact match for $1, please use -list"
		fi
	echo "to see time zones"
	exit 1
	fi
fi
fi
timezone ="$match"
nicetz=$(echo $timezone | sed " s|$ z o ned i r /| |g ")
echo It\'s $(TZ =$timezone date ) in $nicetz
exit 0
