#!/bin/bash

#filelock - A flexible file locking mechanism
retries="10"
action="lock"
nullcmd="/bin/true"

while getopts "lur:" opt; do
	case $opt in
	l)action="lock";;
	u)action="unlock";;
	r)retries="$OPTARG";;
	esac
done
shift $(($OPTIND - 1))

#no parameters left
if [ $# -eq 0 ];then
#	cat << EOF >&2
#Usage: $0 [-l|-u] [-r retries] lockfilename
#Where - l requests a lock (the default), - u requests an unlock , -r X
#specifies a maximum number of retries before it fails ( default = $retries ).
#EOF
	exit 1
fi
#lockfile command does not exist
if [ -z "$(which lockfile | grep -v '^no')" ];then
	echo "$0 failed : 'lockfile' utility non-existant in PATH." >&2
	exit 1
fi

if [ "$action" = "lock" ];then
	if ! lockfile -l -r $retries "$1" 2> /dev/null; then
		echo "Lockfile creation timeout" >&2
		exit 1
	fi
elif [ ! -f "$1" ]; then
	echo "$0: $1 doesn't exist anymore to unlock !"
	exit 1
fi

rm -f "$1"
fi

exit 0
