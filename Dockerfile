FROM debian:stable
RUN apt-get update && apt-get install -y default-jre unzip wget
RUN wget https://github.com/Qortal/qortal/releases/download/v1.4.6/qortal-1.4.6.zip && unzip qortal-1.4.6.zip
WORKDIR qortal
RUN rm qortal.jar && wget https://github.com/Qortal/qortal/releases/download/v1.5.0/qortal.jar && chmod +x start.sh && chmod +x stop.sh
COPY container_files/testchain.json .
COPY container_files/tail_logs.sh .
COPY container_files/start_docker.sh .
CMD ./start_docker.sh
