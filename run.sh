#!/usr/bin/env bash

BASENAME=`basename "$0"`
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#echo -e "SCRIPTPATH: $SCRIPTPATH \n"

if [ "$#" -ne 3 ]; then
	echo -e "usage: \$ ./${BASENAME} \"[CONFIG]\" [USER] [PW]\n"
	exit 1
fi

CONFIG=$1
USER=$2
PW=$3

#docker run -ti -v $SCRIPTPATH/volume:/mnt/volume --privileged --rm debian-ike:0.1 ${CONFIG} ${USER} ${PW}
docker run -d -v $SCRIPTPATH/volume:/mnt/volume --privileged --name ike debian-ike:0.1 ${CONFIG} ${USER} ${PW}

exit 0
