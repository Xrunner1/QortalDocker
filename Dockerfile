FROM debian:stable
RUN apt-get update && apt-get install -y default-jre unzip wget
RUN wget https://github.com/Qortal/qortal/releases/download/v1.4.6/qortal-1.4.6.zip && unzip qortal-1.4.6.zip
WORKDIR qortal
RUN rm qortal.jar && wget https://github.com/Qortal/qortal/releases/download/v1.5.0/qortal.jar && chmod +x start.sh && chmod +x stop.sh
COPY testchain.json .
COPY start-docker.sh .
CMD ./start-docker.sh
