#!/bin/sh

# Make sure mandatory directories exist.
mkdir -p /config/logs

if [ ! -f /config/tmm.jar ]; then
    cp -r /defaults/* /config/
    cd /config
    tar --strip-components=1 -zxvf /config/tmm.tar.gz
fi

# Take ownership of the config directory content.
chown -R $USER_ID:$GROUP_ID /config/*

if [ ! -f /mnt/cron.conf ]; then
#set time to 12:30AM run for movies and 12:45AM run for tvshows
    echo "30 0 * * * /config/tinyMediaManager.sh movie -u --scrapeUnscraped\n45 0 * * * /config/tinyMediaManager.sh tvshow -u --scrapeUnscraped\n" > /mnt/cron.conf
fi
chmod 777 /config/*
chmod 600 /mnt/cron.conf
crontab /mnt/cron.conf

exec "$@"
