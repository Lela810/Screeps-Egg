ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-alpine as screeps

# Install node-gyp dependencies
# We do not pin as we use multiple node versions.
# They are so old that there is no changes to their package registry anyway..
# hadolint ignore=DL3018
RUN --mount=type=cache,target=/etc/apk/cache \
    apk add --no-cache bash python2 make gcc g++ curl ca-certificates openssl git tar bash sqlite fontconfig screen

RUN adduser --disabled-password --home /home/container container
USER container

COPY ./config.yml /home/container/config.yml
COPY ./entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh

USER container
WORKDIR /home/container
ENV  USER=container HOME=/home/container

ENV STARTUP="/bin/sh"

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



