#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo -e "usage:\n\$ docker run -ti --privileged --name ike debian-ike:0.1 \"[CONFIG]\" [USER] [PW]"
		exit 1
fi

BASENAME=`basename "$0"`

CONFIG=$1
USER=$2
PW=$3

IKED_PID=$(pgrep iked)

if [ -z "${IKED_PID}" ]; then
	iked &
fi

# command -v /usr/bin/nano >/dev/null 2>&1 || { echo "please make sure nano is installed. aborting..." >&2; exit 1; }

# set nano as git editor
if [ -f /usr/bin/nano ]; then
  if [ -f /usr/bin/git ]; then
    git config --global core.editor "nano"
  fi
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

		ikec -r "${CONFIG}" -u ${USER} -p ${PW} -a &
		sleep 10
	fi
	check_vpn
}

check_vpn

exit 0
