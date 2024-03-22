FROM ghcr.io/parkervcp/yolks:mongodb_7

USER root

WORKDIR /home/container

RUN apt update && apt upgrade -y 
RUN apt update && apt install -y screen gnupg software-properties-common sudo ca-certificates openssl tar bash fontconfig build-essential tcl git redis-server python2 nodejs npm
RUN apt install -y make gcc g++


COPY ./config.yml /home/container/config.yml
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER container
ENV  USER=container HOME=/home/container

RUN npm install screeps
RUN npx screeps init

ENV STARTUP="/bin/bash"

ENTRYPOINT []
CMD ["/bin/bash", "/entrypoint.sh"]




