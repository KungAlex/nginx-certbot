#!/bin/bash

export DOLLAR='$'

## Nginx logs to stdout
tail -n 0 -f /var/log/nginx/*.log &

first_run () {
    #openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

    rm /etc/nginx/sites-enabled/*
    envsubst < /etc/nginx/sites/defaults-letsencrypt.template > /etc/nginx/sites/defaults-letsencrypt
    ln -s /etc/nginx/sites/defaults-letsencrypt /etc/nginx/sites-enabled/defaults-letsencrypt

    nginx -t
    service nginx restart &
    certbot certonly --webroot --webroot-path=/var/www/html --rsa-key-size 4096 -d $CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN --email $CERTBOT_EMAIL --agree-tos
}

start_ssl () {
    rm /etc/nginx/sites-enabled/*
  #  mkdir /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN
    envsubst < /etc/nginx/sites/mysite.template > /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN
    ln -s /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN /etc/nginx/sites-enabled/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN
    envsubst < /etc/nginx/snippets/ssl-auth.template > /etc/nginx/snippets/ssl-auth.conf

    service nginx restart &
}

## Main
if [ -e "/etc/ssl/certs/dhparam.pem" ] && [ -d "/etc/letsencrypt/live/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN" ]; then
	echo "Start with ssl !"
	start_ssl
else
    echo "setup certbot"
	first_run
	start_ssl
fi

sleep infinity

## Every 24 Hours try to renew certs
#while true
#do
#    certbot renew
#    sleep 24h
#done

