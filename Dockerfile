FROM screepers/screeps-launcher

USER root
RUN adduser --disabled-password --home /home/container container
USER container

COPY ./entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh

USER container
WORKDIR /home/container
ENV  USER=container HOME=/home/container

ENV STARTUP="/bin/sh"

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



