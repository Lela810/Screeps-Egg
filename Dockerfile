FROM screepers/screeps-launcher

LABEL       author="Leandro Klaus" maintainer="info@lklaus.ch"

LABEL       org.opencontainers.image.source="https://github.com/Lela810/Screeps-Egg"
LABEL       org.opencontainers.image.licenses=MIT

USER root
ENV DEBIAN_FRONTEND noninteractive

RUN useradd -m -u 998 -d /home/container -s /bin/bash container

RUN apt update && apt install -y nodejs npm nano screen

USER container

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/container
ENV USER=container HOME=/home/container

ENV STARTUP="/bin/sh"
STOPSIGNAL SIGINT

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



