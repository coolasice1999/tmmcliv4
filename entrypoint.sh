#!/bin/sh

if [ ! -f /config/cron.conf ]; then
#set time to 12:30AM run for movies and 12:45AM run for tvshows
    echo -e "30 0 * * * /config/tinyMediaManager.sh movie -u --scrapeUnscraped\n45 0 * * * /config/tinyMediaManager.sh tvshow -u --scrapeUnscraped\n" > /config/cron.conf
fi
chmod 777 /config/*
chmod 600 /config/cron.conf
crontab /config/cron.conf

exec "$@"
