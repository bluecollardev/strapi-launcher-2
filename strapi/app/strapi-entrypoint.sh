#!/bin/bash
set -ea

touch entrypoint-log.txt
echo "Starting entrypoint script..." >> entrypoint-log.txt
echo "Export variables..." >> entrypoint-log.txt

export HOST=$HOST
export PORT=$PORT
export DATABASE_CLIENT=$DATABASE_CLIENT
export DATABASE_HOST=$DATABASE_HOST
export DATABASE_PORT=$DATABASE_PORT
export DATABASE_NAME=$DATABASE_NAME
export DATABASE_USERNAME=$DATABASE_USERNAME
export DATABASE_PASSWORD=$DATABASE_PASSWORD
export APP_KEYS=$APP_KEYS
export API_TOKEN_SALT=$API_TOKEN_SALT
export ADMIN_JWT_SECRET=$ADMIN_JWT_SECRET
export JWT_SECRET=$JWT_SECRET
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_ACCESS_SECRET=$AWS_ACCESS_SECRET
export AWS_REGION=$AWS_REGION
export AWS_BUCKET=$AWS_BUCKET
# Rebuild the admin panel or Strapi admin will use port 1337
# https://github.com/strapi/strapi/issues/12826

echo "Rebuild Strapi admin..." >> entrypoint-log.txt
yarn build >> ./entrypoint-log.txt

echo "Strapi rebuild complete, entrypoint script success" >> ./entrypoint-log.txt
exec "$@"
