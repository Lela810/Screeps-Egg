FROM screepers/screeps-launcher

USER root
RUN useradd -m -d /home/container -s /bin/bash container
USER container

COPY ./config.yml /config.yml
COPY ./entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh

USER container
WORKDIR /home/container
ENV  USER=container HOME=/home/container

ENV STARTUP="/bin/sh"

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



