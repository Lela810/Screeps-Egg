FROM screepers/screeps-launcher:latest

USER root

RUN adduser --disabled-password --home /home/container container
WORKDIR /home/container

RUN apt update && apt upgrade -y
RUN apt update && apt install -y screen gnupg software-properties-common sudo ca-certificates openssl tar bash fontconfig

COPY ./config.yml /home/container/config.yml
COPY ./entrypoint.sh /entrypoint.sh

RUN chown -R container /home/container

RUN chmod +x /entrypoint.sh

USER container
ENV  USER=container HOME=/home/container

ENV STARTUP="/bin/bash"

ENTRYPOINT []
CMD ["/bin/bash", "/entrypoint.sh"]




