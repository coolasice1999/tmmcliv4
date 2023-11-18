#!/bin/sh

if [ ! -f /mnt/cron.conf ]; then
#set time to 12:30AM run for movies and 12:45AM run for tvshows
    echo -e "30 0 * * * /config/tinyMediaManager.sh movie -u --scrapeUnscraped\n 45 0 * * * /config/tinyMediaManager.sh tvshow -u --scrapeUnscraped" > /mnt/cron.conf
fi
chmod 777 /config/*
chmod 600 /mnt/cron.conf
crontab /mnt/cron.conf

exec "$@"
