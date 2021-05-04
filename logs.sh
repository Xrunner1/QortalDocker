#!/bin/bash

#
# Usage: pass the network port of the required container as the first argument
#
# e.g:
# ./logs.sh 62392
#

NET_PORT=$1
NET_PORT=${NET_PORT:=62392}
INSTANCE_NAME="qortal_${NET_PORT}"
CONTAINER_ID=$(docker ps -aqf "name=${INSTANCE_NAME}")

if [ -z "${CONTAINER_ID}" ]; then
    # Container instance isn't running yet
    echo "Error: could not find a container with name ${INSTANCE_NAME}. Please use ./run.sh first."
else
    # Already running
    echo "Retriving logs from container ${INSTANCE_NAME} with ID ${CONTAINER_ID}..."
    echo
    echo "Startup logs:"
    docker logs "${CONTAINER_ID}"
    echo
    echo "Runtime logs:"
    docker exec -it "${CONTAINER_ID}" ./tail_logs.sh
fi
