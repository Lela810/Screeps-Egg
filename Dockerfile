FROM screepers/screeps-launcher

USER root
ENV          DEBIAN_FRONTEND noninteractive

RUN          useradd -m -u 998 -d /home/container -s /bin/bash container

USER container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh

WORKDIR /home/container
ENV  USER=container HOME=/home/container

ENV STARTUP="/bin/sh"

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



