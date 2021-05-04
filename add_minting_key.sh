#!/bin/bash

#
# Usage: pass the network port of the required container as the first argument
#
# e.g:
# ./remove_minting_key.sh 62392
#

NET_PORT=$1
MINTING_KEY=$2

if [ -z $NET_PORT ]; then
    echo "Error: missing network port number as first argument"
    exit
fi
if [ -z $MINTING_KEY ]; then
    echo "Error: missing reward share private key as second argument"
    exit
fi

INSTANCE_NAME="qortal_${NET_PORT}"
EXISTING_RUNNING_CONTAINER_ID=$(docker ps -aqf "name=${INSTANCE_NAME}" --filter status=running)

if [ ! -z "${EXISTING_RUNNING_CONTAINER_ID}" ]; then
    echo "Adding minting key ${MINTING_KEY}..."
    docker exec -it "${EXISTING_RUNNING_CONTAINER_ID}" curl -X POST "http://localhost:${NET_PORT}/admin/mintingaccounts" -H "accept: text/plain" -H "Content-Type: text/plain" -d "${MINTING_KEY}"
    echo
    echo "Minting accounts:"
    docker exec -it "${EXISTING_RUNNING_CONTAINER_ID}" curl "http://localhost:${NET_PORT}/admin/mintingaccounts" | jq
else
    echo "Error: could not find a container with name ${INSTANCE_NAME}. Please use ./run.sh first."
fi
