#!/usr/bin/env bash

if [ "$#" -ne 5 ]; then
    echo -e "usage:\n\$ docker run -ti -p [port]:[port] --privileged --name ike debian-ikec [config] [user] [PW] [TARGET] [PORT]"
		exit 1
fi

BASENAME=`basename "$0"`

CONFIG=$1
USER=$2
PW=$3
TARGET=$4
PORT=$5

IKED_PID=$(pgrep iked)

if [ -z "${IKED_PID}" ]; then
	iked &
fi

function finish {
  echo "Detected SIGTERM, shuting down..."
	killall -9 ikec &>/dev/null
	killall -9 socat &>/dev/null
	exit 0
}
trap finish TERM INT


check_vpn () {
	# Check for specific interface
	TUNNEL=$(ifconfig | grep "tap0")
	# echo "$TUNNEL"
	if [ -n "$TUNNEL" ]; then
		echo "$(date +"%T") - $BASENAME: tap0 is up"
		sleep 20
	else
		echo "$(date +"%T") - $BASENAME: tap0 is down. reconnecting.."
		killall -9 ikec &>/dev/null
		killall -9 socat &>/dev/null

		socat TCP4-LISTEN:"${PORT}",fork TCP4:"${TARGET}" &
		ikec -r "${CONFIG}" -u "${USER}" -p "${PW}" -a &
		sleep 10
	fi
	check_vpn
}

check_vpn

exit 0
