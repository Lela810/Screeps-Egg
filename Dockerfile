FROM screepers/screeps-launcher:v1.15.1

WORKDIR /screeps

USER root

RUN apt update && apt install -y gnupg software-properties-common redis sudo
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
RUN add-apt-repository 'deb https://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main'
RUN apt update && apt install -y mongodb-org
RUN mkdir -p /data/db /data/configdb && chown -R screeps:screeps /data/db /data/configdb
RUN adduser -D -h /home/container container

ADD https://raw.githubusercontent.com/Lela810/Screeps-Egg/main/src/config.yml /opt/screeps/config.yml

WORKDIR /home/container
ADD https://raw.githubusercontent.com/Lela810/Screeps-Egg/main/src/entrypoint.sh /home/container/entrypoint.sh

RUN chmod +x entrypoint.sh


ENTRYPOINT [ "./entrypoint.sh" ]
#WORKDIR /opt/screeps





#ADD https://github.com/screepers/screeps-launcher/releases/download/v1.15.1/screeps-launcher_v1.15.1_linux_amd64 screeps-launcher
#RUN chmod +x screeps-launcher




