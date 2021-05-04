FROM debian:stable
RUN apt-get update && apt-get install -y default-jre unzip wget curl jq
RUN wget https://github.com/Qortal/qortal/releases/download/v1.4.6/qortal-1.4.6.zip && unzip qortal-1.4.6.zip
WORKDIR qortal
RUN rm qortal.jar && wget http://node1.qortal.uk/builds/qortal-newChainWeight.1.jar && mv qortal-newChainWeight.1.jar qortal.jar && chmod +x start.sh && chmod +x stop.sh
COPY container_files/* .
CMD ./start_docker.sh
