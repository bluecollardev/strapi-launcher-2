ARG NODE_VERSION
FROM node:${NODE_VERSION} as strapi-cms
RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash
RUN mkdir /srv/app && chown 1000:1000 -R /srv/app
WORKDIR /srv/app
VOLUME /srv/app
COPY . .
ENTRYPOINT ["docker-entrypoint.sh"]
