ARG NODE_VERSION
FROM node:${NODE_VERSION} as node-base
RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash

FROM node-base as strapi-base
ARG STRAPI_PKG
# Optionally bust cache
# ARG CACHEBUST=0
RUN yarn global add ${STRAPI_PKG}
RUN mkdir /srv/build && chown 1000:1000 -R /srv/build
WORKDIR /srv/build
VOLUME /srv/build

FROM strapi-base as strapi-cms-base
ARG DATABASE_CLIENT
ARG DATABASE_HOST
ARG DATABASE_PORT
ARG DATABASE_NAME
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG DATABASE_SSL
ARG EXTRA_ARGS
# Optionally bust cache
# ARG CACHEBUST=0
RUN DOCKER=true strapi new . \
  --dbclient=${DATABASE_CLIENT} \
  --dbhost=${DATABASE_HOST} \
  --dbport=${DATABASE_PORT} \
  --dbname=${DATABASE_NAME} \
  --dbusername=${DATABASE_USERNAME} \
  --dbpassword=${DATABASE_PASSWORD} \
  --dbssl=${DATABASE_SSL} \
  ${EXTRA_ARGS}
COPY ./docker-entrypoint.sh /usr/local/bin/
# Copy custom files into our strapi installation
# Use unaliased cp to force overwrite
COPY ./app /srv/build
# Install strapi core dependencies
RUN yarn install
# Add any additional dependencies or strapi plugins here
RUN yarn add @strapi/provider-upload-aws-s3
RUN ls -la /srv/build
ENTRYPOINT ["docker-entrypoint.sh"]

