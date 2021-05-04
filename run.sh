#!/bin/bash

#
# Usage: pass the number of instances to create as the first argument
# Include the --restart argument to force restart existing instances
#
# e.g:
# ./run.sh 3 --restart
#

INSTANCES=$1
INSTANCES=${INSTANCES:=1}
CURRENT_INSTANCE=0
START_API_PORT=62391
START_NET_PORT=62392

FORCE_RESTART=0
if [[ "$@" = *"--restart"* ]]; then
    FORCE_RESTART=1
fi

while [ "${CURRENT_INSTANCE}" -lt "${INSTANCES}" ]; do
    PORT_OFFSET=$((CURRENT_INSTANCE*10))
    API_PORT=$((START_API_PORT+PORT_OFFSET))
    NET_PORT=$((START_NET_PORT+PORT_OFFSET))
    INSTANCE_NAME="qortal_${NET_PORT}"
    EXISTING_CONTAINER_ID=$(docker ps -aqf "name=${INSTANCE_NAME}")
    EXISTING_RUNNING_CONTAINER_ID=$(docker ps -aqf "name=${INSTANCE_NAME}" --filter status=running)

    if [ -z "${EXISTING_RUNNING_CONTAINER_ID}" ] || [ "${FORCE_RESTART}" -eq 1 ]; then

        if [ ! -z "${EXISTING_CONTAINER_ID}" ]; then
            echo "Stopping container ${INSTANCE_NAME} with ID ${EXISTING_CONTAINER_ID}..."
            docker exec -it "${EXISTING_CONTAINER_ID}" ./stop_docker.sh
            docker container stop "${EXISTING_CONTAINER_ID}"
            docker rm "${EXISTING_CONTAINER_ID}"
        fi

        # Container not running - start it
        echo "Starting new container ${INSTANCE_NAME} with API port ${API_PORT} and network port ${NET_PORT}..."
        docker volume create "${INSTANCE_NAME}"
        docker run -d --name "${INSTANCE_NAME}" --env API_PORT="${API_PORT}" --env NET_PORT="${NET_PORT}" -p 127.0.0.1:${NET_PORT}:${NET_PORT} -v ${INSTANCE_NAME}:/qortal -it qortal

    else
        # Already running
        echo "Qortal is already running with network port ${NET_PORT} using container ID ${EXISTING_CONTAINER_ID}. Doing nothing. Use --restart argument to restart it."
    fi

    CURRENT_INSTANCE=$((CURRENT_INSTANCE+1))
done
