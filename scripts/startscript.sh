#!/bin/bash


## Nginx logs to stdout
tail -n 0 -f /var/log/nginx/*.log &tail -n 0 -f /var/log/nginx/*.log &

## Setup for Certbot
# TODO run certbot only on the first startup

first_run () {
    echo "first_run: create ssl certs"
    openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

    rm /etc/nginx/sites-enabled/*
    ln -s /etc/nginx/sites/defaults-letsencrypt /etc/nginx/sites-enabled/defaults-letsencrypt

    nginx -t
    service nginx restart &
    certbot certonly --webroot --webroot-path=/var/www/html -d $CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN --email $CERTBOT_EMAIL --agree-tos
}

start_ssl () {
    rm /etc/nginx/sites-enabled/*
    ln -s /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN /etc/nginx/sites-enabled/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN
    service nginx restart &
}

start_default () {
    rm /etc/nginx/sites-enabled/*
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    service nginx restart &
}


if [ -e "/etc/ssl/certs/dhparam.pem" ]; then
	echo "Start with ssl !"
	start_ssl
else
	first_run
fi


## TODO set Cron-Job for Certbot on $CERTBOT_RENEWAL_DAYS
sleep infinity