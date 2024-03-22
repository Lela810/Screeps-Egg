ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-alpine as screeps

USER root

RUN apk add --no-cache --update curl ca-certificates openssl git tar bash sqlite fontconfig \
    && adduser --disabled-password --home /home/container container

# Install node-gyp dependencies
# We do not pin as we use multiple node versions.
# They are so old that there is no changes to their package registry anyway..
# hadolint ignore=DL3018
RUN --mount=type=cache,target=/etc/apk/cache \
    apk add --no-cache bash python2 make gcc g++

# Install screeps
WORKDIR /home/container
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm clean-install

# Initialize screeps, similar to `screeps init`
RUN cp -a /home/container/node_modules/@screeps/launcher/init_dist/.screepsrc ./ && \
    cp -a /home/container/node_modules/@screeps/launcher/init_dist/db.json ./ && \
    cp -a /home/container/node_modules/@screeps/launcher/init_dist/assets/ ./

# Gotta remove this Windows carriage return shenanigans
RUN sed -i "s/\r//" .screepsrc

FROM node:${NODE_VERSION}-alpine as server
# hadolint ignore=DL3018
RUN --mount=type=cache,target=/var/cache/apk \
    apk add --no-cache git screen

COPY --from=screeps --chown=node:node /home/container /home/container/

# Init mods package
RUN mkdir ./mods && echo "{}" > ./mods/package.json

COPY screeps-cli.js ./bin/cli
COPY screeps-start.js ./bin/start

ENV SERVER_DIR=/home/container NODE_ENV=production PATH="/home/container/bin:${PATH}"

HEALTHCHECK --start-period=10s --interval=30s --timeout=3s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:21025/api/version || exit 1


COPY ./config.yml /home/container/config.yml
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /home/container/bin/cli
RUN chmod +x /home/container/bin/start

USER container
ENV  USER=container HOME=/home/container


ENV STARTUP="/bin/sh"

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



