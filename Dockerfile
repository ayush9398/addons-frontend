FROM node:6-slim

# Install node_modules into a different directory to avoid npm/npm#9863.
RUN mkdir -p /srv/node
ADD package.json /srv/node/
WORKDIR /srv/node

RUN buildDeps=' \
    git \
    ' && \
    # install deps
    apt-get update -y && \
    apt-get install -y --no-install-recommends $buildDeps && \
    yarn install && \
    # cleanup
    # apt-get purge -y $buildDeps && \
    rm -rf /var/lib/apt/lists/*

ADD . /srv/code/
WORKDIR /srv/code

# The V2 Pipeline expects version.json to be located in /app/
# As a temporary measure symlink to the version.json generated by Circle-CI
RUN mkdir /app && ln -s /srv/code/version.json /app/version.json

# Replace the local node_modules with the ones we installed above.
RUN rm -rf node_modules
RUN ln -s /srv/node/node_modules

ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 4000

CMD yarn start
