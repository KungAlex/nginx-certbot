#!/bin/bash

## Nginx logs to stdout
tail -n 0 -f /var/log/nginx/*.log &tail -n 0 -f /var/log/nginx/*.log &

first_run () {
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

recreate_cert () {
echo "recreate_cert"
certbot renew --pre-hook "service nginx stop" --post-hook "service nginx start"
}

## Main
if [ -e "/etc/ssl/certs/dhparam.pem" ] && [ -d "/etc/letsencrypt/live/auth.kungf.ooo" ]; then
	echo "Start with ssl !"
	start_ssl
else
    echo "setup certbot"
	first_run
	start_ssl
fi

# TODO set Cron-Job for Certbot on $CERTBOT_RENEWAL_DAYS (on host-system!)
# TODO set $CERTBOT_ENV

# crontab -e -> 43 6 * * * certbot renew --post-hook "systemctl reload nginx"
sleep infinity