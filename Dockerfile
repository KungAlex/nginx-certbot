############################################################
# Dockerfile for Nginx
# based on ubuntu:latest
############################################################

FROM ubuntu:latest
MAINTAINER kungalex <alexander-kleinschmidt@smail-fh-koeln.de>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install apt-utils software-properties-common python-software-properties -y

# install Nginx.
RUN apt-get install -y nginx && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data:www-data /var/lib/nginx

## setup Certbot
## https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04
RUN add-apt-repository ppa:certbot/certbot -y && \
    apt-get update -y && apt-get install certbot -y && \
    rm -rf /var/lib/apt/lists/*

# define directory for well-know hosts.
RUN mkdir /var/www/html/.well-known

# define mountable directories
VOLUME ["/etc/nginx/sites", "/etc/nginx/snippets/", "/etc/letsencrypt"]

# define working directory.
WORKDIR ./etc/nginx/
