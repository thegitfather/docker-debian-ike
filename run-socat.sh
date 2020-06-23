#!/usr/bin/env bash

BASENAME=`basename "$0"`

if [ "$#" -ne 5 ]; then
	echo -e "usage: \$ ./${BASENAME} \"[CONFIG]\" [USER] [PW] [TARGET] [PORT]\n"
	exit 1
fi

CONFIG=$1
USER=$2
PW=$3
TARGET=$4
PORT=$5

docker run -ti -p ${PORT}:${PORT} --privileged --rm debian-ike:0.1 ${CONFIG} ${USER} ${PW} ${TARGET} ${PORT}
#docker run -d -p ${PORT}:${PORT} --privileged --name ike debian-ike:0.1 ${CONFIG} ${USER} ${PW} ${TARGET} ${PORT}

exit 0
