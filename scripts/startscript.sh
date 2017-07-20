#!/bin/bash


## Nginx logs to stdout
tail -n 0 -f /var/log/nginx/*.log &tail -n 0 -f /var/log/nginx/*.log &

## Setup for Certbot
# TODO run certbot only on the first startup
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
ln -s /etc/nginx/sites/defaults-letsencrypt /etc/nginx/sites-enabled/defaults-letsencrypt
rm /etc/nginx/sites-enabled/default

nginx -t
service nginx restart &

certbot certonly --webroot --webroot-path=/var/www/html -d $CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN --email $CERTBOT_EMAIL --agree-tos

rm /etc/nginx/sites-enabled/defaults-letsencrypt
ln -s /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN /etc/nginx/sites-enabled/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN

service nginx restart &

## TODO set Cron-Job for Certbot on $CERTBOT_RENEWAL_DAYS
sleep infinity