#!/bin/bash
BLINKSTICK="/usr/local/bin/blinkstick"

# commands to run on state changes
# customize to your heart's will but keep in mind:
# - blinkstick will not exit while doing the repeats
# - the script doesn't check if it's already running or the previous state
# - if your blink pattens run longer than the cron interval for banamon
#   you will get multiple processes
# Be sure to add a pull request if you implement state and pid
# The way it's configured now it will "breathe" every minute if the
# state is the same

function warning {
	$BLINKSTICK --set-color yellow --morph --duration 2000
	$BLINKSTICK --set-color yellow --pulse --duration 2000 --repeats 1
	$BLINKSTICK --set-color yellow
}

function critical {
	$BLINKSTICK --set-color red --morph --duration 2000
	$BLINKSTICK --set-color red --pulse --duration 2000 --repeats 1
	$BLINKSTICK --set-color red
}

function ok {
	$BLINKSTICK --set-color blue --morph --duration 2000
	$BLINKSTICK --set-color blue --pulse --duration 2000 --repeats 1
	$BLINKSTICK --set-color blue
}
function usage {
echo "Usage: banamon.sh -u nagios -p password -u http://www.example.com/nagios/cgi-bin/status.cgi"
echo
echo "Options:"
echo "	-h, --help"
echo "		Print detailed usage information"
echo "	-U, --url"
echo "		URL where nagios status is to be found"
echo "		(e.g. http://www.example.com/nagios/cgi-bin/status.cgi"
echo "	-u, --user "
echo "		Nagios username"
echo "	-p, --password "
echo "		Nagios password"
echo "	-f, --status "
echo "		Path to nagios status file, this excludes remote url access"
exit
}
[ $# -eq 0 ] && usage
	
while [ "$1" != "" ]; do
	case $1 in
		-u | --user ) shift
			NAGUSER=$1
			;;
		-p | --password ) shift
			NAGPASS=$1
			;;
		-U | --url ) shift
			NAGURL=$1
			;;
		-f | --status ) shift
			NAGSTAT=$1
			;;
		-h | --help ) usage
			;;
		* ) usage
	esac
	shift
done
if [ -z "$NAGSTAT" ]; then
	if [ -z "$NAGUSER" ]; then
		echo "Nagios user has to be specified"
		usage
	elif [ -z "$NAGPASS" ]; then
		echo "Nagios password has to be specified"
		usage
	elif [ -z "$NAGURL" ]; then
		echo "Nagios status URL has to be specified"
		usage
	fi
	RESULT=$(curl -s --user ${NAGUSER}:${NAGPASS} $NAGURL | sed -e :a -e 's/<[^>]*>//g;/</N;//ba')
else
	if [ ! -f "$NAGSTAT" ]; then
		echo "$NAGSTAT cannot be read"
		usage
	fi
	RESULT=$(cat $NAGSTAT)
fi
if echo "$RESULT" | grep "CRITICAL">/dev/null 2>&1 ; then
	critical
elif echo "$RESULT" | grep "WARNING">/dev/null 2>&1; then
	warning
else
	ok
fi

