#!/bin/bash
set -ea

touch entrypoint-log.txt
echo "Starting entrypoint script..." >> entrypoint-log.txt

# Copy build artifacts to mounted volume
cp -rf /srv/build/. /srv/app
echo "Files in build volume" >> ./entrypoint-log.txt
ls -la /srv/build >> ./entrypoint-log.txt
echo "Files in app volume" >> ./entrypoint-log.txt
ls -la /srv/app >> ./entrypoint-log.txt

echo "Strapi rebuild complete, entrypoint script success" >> ./entrypoint-log.txt
