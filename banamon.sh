#!/bin/bash
# commands to run on WARNING status
function warning {
	/usr/local/bin/blinkstick --set-color yellow
}

function critical {
	/usr/local/bin/blinkstick --set-color red
}

function ok {
	/usr/local/bin/blinkstick --set-color black
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
		-h | --help ) usage
			;;
		* ) usage
	esac
	shift
done

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

if echo "$RESULT" | grep "CRITICAL">/dev/null 2>&1 ; then
	critical
elif echo "$RESULT" | grep "WARNING">/dev/null 2>&1; then
	warning
else
	ok
fi

