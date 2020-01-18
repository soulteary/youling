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

RUN git clone https://github.com/TryGhost/mobiledoc-kit.git /mobiledoc-kit && \
    cd /mobiledoc-kit && \
    git checkout 3b0f375d32f7183a4eee9cce5373ebabeb249165 && \
    cp /patches/mobiledoc-kit/event-manager.js /mobiledoc-kit/src/js/editor/event-manager.js && \
    yarn && \
    cp -r /mobiledoc-kit/dist /patches/mobiledoc-kit/dist && \
    rm -rf /mobiledoc-kit

RUN git clone --recurse-submodules https://github.com/TryGhost/Ghost.git /Ghost && \
    cd /Ghost && \
    git checkout 3.3.0 && \
    yarn setup

RUN rm -rf /Ghost/core/client/node_modules/\@tryghost/mobiledoc-kit/dist && \
    cp -r /patches/mobiledoc-kit/dist /Ghost/core/client/node_modules/\@tryghost/mobiledoc-kit/

WORKDIR /Ghost

RUN grunt prod

EXPOSE 2368

CMD ["npm", "start"]
