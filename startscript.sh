openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

cp /etc/nginx/sites-available/defaults-letsencrypt /etc/nginx/sites-enabled/defaults-letsencrypt
service nginx restart

certbot certonly --webroot --webroot-path=/var/www/html -d auth.kungf.ooo --email kungalex@kungf.ooo


## TODO change nginx config file and restart with nginx -t -c file
#rm /etc/nginx/sites-enabled/defaults-letsencrypt
#cp /etc/nginx/scripts/auth.kungfooo /etc/nginx/sites-enabled/auth.kungfooo
service nginx restart

## TODO set Cron-Job for Certbot
# sleep infinity