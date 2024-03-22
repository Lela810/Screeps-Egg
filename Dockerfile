ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-alpine as screeps

# Install node-gyp dependencies
# We do not pin as we use multiple node versions.
# They are so old that there is no changes to their package registry anyway..
# hadolint ignore=DL3018
RUN --mount=type=cache,target=/etc/apk/cache \
    apk add --no-cache bash python2 make gcc g++ curl ca-certificates openssl git tar bash sqlite fontconfig

# Install screeps
WORKDIR /screeps
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm clean-install

# Initialize screeps, similar to `screeps init`
RUN cp -a /screeps/node_modules/@screeps/launcher/init_dist/.screepsrc ./ && \
    cp -a /screeps/node_modules/@screeps/launcher/init_dist/db.json ./ && \
    cp -a /screeps/node_modules/@screeps/launcher/init_dist/assets/ ./

# Gotta remove this Windows carriage return shenanigans
RUN sed -i "s/\r//" .screepsrc

FROM node:${NODE_VERSION}-alpine as server

RUN adduser --disabled-password --home /home/container container


# hadolint ignore=DL3018
RUN --mount=type=cache,target=/var/cache/apk \
    apk add --no-cache git screen

USER container
COPY --from=screeps --chown=container:container /screeps /home/container/

# Init mods package
RUN mkdir /home/container/mods && echo "{}" > /home/container/mods/package.json

COPY screeps-cli.js /home/container/bin/cli
COPY screeps-start.js /home/container/bin/start

ENV SERVER_DIR=/home/container NODE_ENV=production PATH="/screeps/bin:${PATH}"

HEALTHCHECK --start-period=10s --interval=30s --timeout=3s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:21025/api/version || exit 1


COPY ./config.yml /home/container/config.yml
COPY ./entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh
RUN chmod +x /home/container/bin/cli
RUN chmod +x /home/container/bin/start

USER container
WORKDIR /home/container
ENV  USER=container HOME=/home/container

ENTRYPOINT []
CMD ["/bin/sh", "/entrypoint.sh"]



