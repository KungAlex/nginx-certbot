[![Build Status](https://travis-ci.org/KungAlex/ngix-certbot.svg?branch=master)](https://travis-ci.org/KungAlex/ngix-certbot)
# Docker Image for Nginx with automatic Certbot script

TODO

## Requirements

TODO

## Config

- create docker-compose.yaml     
        
    services:
    
      nginx:
        build: .
        image: kungalex/nginx-certbot:dev-1.0
    
        volumes:
          - /etc/ssl/certs/dhparam.pem:/etc/ssl/certs/dhparam.pem:ro
          - cert-data:/etc/letsencrypt:rw
          - ./mysite.template:/etc/nginx/sites/mysite.template
    
        env_file: nginx.env

        ports:
         - "80:80"
         - "443:443"

      app:
        image: k8s.gcr.io/echoserver:1.4    
        
      volumes:
        cert-data:


- mount site.template

- create dhparam `openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096`
- change nginx.env to your domain

# Run
docker-compose up




