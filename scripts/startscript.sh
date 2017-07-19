#!/bin/bash

#openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
#echo $CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN

## TODO use certbot nginx config file and restart with nginx -t -c file
#cp /etc/nginx/sites-available/defaults-letsencrypt /etc/nginx/sites-enabled/defaults-letsencrypt
service nginx restart

## TODO run certbot on the first startup
#certbot certonly --webroot --webroot-path=/var/www/html -d $CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN --email $CERTBOT_EMAIL


## TODO change nginx config file and restart with nginx -t -c file
#rm /etc/nginx/sites-enabled/defaults-letsencrypt
#cp /etc/nginx/scripts/auth.kungfooo /etc/nginx/sites-enabled/auth.kungfooo
#service nginx restart

## TODO set Cron-Job for Certbot on $CERTBOT_RENEWAL_DAYS
# sleep infinity