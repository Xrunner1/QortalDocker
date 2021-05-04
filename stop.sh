#!/bin/bash

#
# Usage: pass the network port of the required container as the first argument,
# or use "all" to stop all Qortal containers
#
# e.g:
# ./stop.sh 62392
# ./stop.sh all
#

NET_PORT=$1
NET_PORT=${NET_PORT:=62392}

if [[ "${NET_PORT}" == "all" ]]; then
echo "Stopping all Qortal instances..."
    NAME_FILTER="qortal_"
else
echo "Stopping Qortal instance with network port ${NET_PORT}..."
    NAME_FILTER="qortal_${NET_PORT}"
fi

CONTAINER_IDS=$(docker ps -a -q --filter name="${NAME_FILTER}")
if [ -z "${CONTAINER_IDS}" ]; then
    echo "Container(s) are not running. Doing nothing."
    exit
fi

docker exec -it $(docker ps -a -q --filter name="${NAME_FILTER}") ./stop.sh -t
docker stop $(docker ps -a -q --filter name="${NAME_FILTER}")
docker rm $(docker ps -a -q --filter name="${NAME_FILTER}")
