ARG NODE_VERSION
FROM node:${NODE_VERSION} as strapi-cms

# Optionally bust cache
# ARG CACHEBUST=0

ARG HOST
ARG PORT
ARG DATABASE_CLIENT
ARG DATABASE_HOST
ARG DATABASE_PORT
ARG DATABASE_NAME
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG APP_KEYS
ARG API_TOKEN_SALT
ARG ADMIN_JWT_SECRET
ARG JWT_SECRET
ARG AWS_ACCESS_KEY_ID
ARG AWS_ACCESS_SECRET
ARG AWS_REGION
ARG AWS_BUCKET

ENV HOST=$HOST
ENV PORT=$PORT
ENV DATABASE_CLIENT=$DATABASE_CLIENT
ENV DATABASE_HOST=$DATABASE_HOST
ENV DATABASE_PORT=$DATABASE_PORT
ENV DATABASE_NAME=$DATABASE_NAME
ENV DATABASE_USERNAME=$DATABASE_USERNAME
ENV DATABASE_PASSWORD=$DATABASE_PASSWORD
ENV APP_KEYS=$APP_KEYS
ENV API_TOKEN_SALT=$API_TOKEN_SALT
ENV ADMIN_JWT_SECRET=$ADMIN_JWT_SECRET
ENV JWT_SECRET=$JWT_SECRET
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_ACCESS_SECRET=$AWS_ACCESS_SECRET
ENV AWS_REGION=$AWS_REGION
ENV AWS_BUCKET=$AWS_BUCKET

RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash
RUN mkdir /srv/app && chown 1000:1000 -R /srv/app

WORKDIR /srv/app
VOLUME /srv/app

COPY . .

ENTRYPOINT ["./strapi-entrypoint.sh"]
CMD ["yarn", "start"]
