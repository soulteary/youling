FROM node:12-alpine
LABEL maintainer="soulteary@gmail.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN echo '' > /etc/apk/repositories && \
    echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.10/main"         >> /etc/apk/repositories && \
    echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.10/community"    >> /etc/apk/repositories && \
    echo "Asia/Shanghai" > /etc/timezone

RUN apk update && apk add git && \
    yarn global add knex-migrator grunt-cli ember-cli bower

COPY patches/mobiledoc-kit/event-manager.js /patches/mobiledoc-kit/event-manager.js

ARG GHOST_RELEASE_VERSION=3.9.0
RUN git clone --recurse-submodules https://github.com/TryGhost/Ghost.git --depth=1 --branch=$GHOST_RELEASE_VERSION /Ghost && \
    cd /Ghost && \
    yarn setup

# FOR GHOST 3.9.0
ARG MOBILEDOC_KIT_VERSION=v0.11.1-ghost.4
ARG EVENT_MANAGER_HASH=9a0456060f1c816a0a66bdcf3363e928
RUN git clone https://github.com/TryGhost/mobiledoc-kit.git /mobiledoc-kit && \
    cd /mobiledoc-kit && \
    git checkout $MOBILEDOC_KIT_VERSION && \
    (echo "$EVENT_MANAGER_HASH  /mobiledoc-kit/src/js/editor/event-manager.js" | md5sum -c -s -) && \
    cp /patches/mobiledoc-kit/event-manager.js /mobiledoc-kit/src/js/editor/event-manager.js && \
    yarn && \
    cp -r /mobiledoc-kit/dist /patches/mobiledoc-kit/dist && \
    rm -rf /mobiledoc-kit

RUN rm -rf /Ghost/core/client/node_modules/\@tryghost/mobiledoc-kit/dist && \
    cp -r /patches/mobiledoc-kit/dist /Ghost/core/client/node_modules/\@tryghost/mobiledoc-kit/

WORKDIR /Ghost

RUN grunt prod

EXPOSE 2368

CMD ["npm", "start"]
