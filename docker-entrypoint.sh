#!/bin/bash

export DOLLAR='$'

tail -n 0 -f /var/log/nginx/*.log &

first_run () {
    rm /etc/nginx/sites-enabled/*
    envsubst < /etc/nginx/sites/defaults-letsencrypt.template > /etc/nginx/sites/defaults-letsencrypt
    ln -s /etc/nginx/sites/defaults-letsencrypt /etc/nginx/sites-enabled/defaults-letsencrypt

    nginx -t
    service nginx restart &
    certbot certonly --webroot --webroot-path=/var/www/html --rsa-key-size 4096 -d $CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN --email $CERTBOT_EMAIL --agree-tos --noninteractive
}

start_ssl () {
    rm /etc/nginx/sites-enabled/*
    envsubst < /etc/nginx/sites/mysite.template > /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN
    ln -s /etc/nginx/sites/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN /etc/nginx/sites-enabled/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN
    envsubst < /etc/nginx/snippets/ssl-auth.template > /etc/nginx/snippets/ssl-auth.conf

    service nginx restart &
}

if [ -e "/etc/nginx/sites/mysite.template" ] && [ -e "/etc/ssl/certs/dhparam.pem" ]; then

    if [ -d "/etc/letsencrypt/live/$CERTBOT_DOMAIN_PREFIX.$CERTBOT_DOMAIN" ]; then
        echo "Start with ssl !"
        start_ssl
    else
        echo "start certbot"
        first_run
        start_ssl
    fi
else
    echo "please mount nginx config in /etc/nginx/sites/mysite.template and create dhparam"
    exit 1
fi

while true; do sleep 30; certbot renew --noninteractive; sleep 12h; done;

