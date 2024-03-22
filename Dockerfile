FROM ghcr.io/parkervcp/yolks:mongodb_7

USER root

WORKDIR /home/container

RUN apt update && apt upgrade -y 
RUN apt install -y curl npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt install -y nodejs
RUN apt update && apt install -y screen gnupg software-properties-common sudo ca-certificates openssl tar bash fontconfig build-essential tcl git redis-server python2


COPY ./config.yml /home/container/config.yml
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER container
ENV  USER=container HOME=/home/container

ENV STARTUP="/bin/bash"

ENTRYPOINT []
CMD ["/bin/bash", "/entrypoint.sh"]




