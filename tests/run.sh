#!/usr/bin/env bash

mkdir -p storage/media storage/caddy_config storage/caddy_data storage/postgres storage/redis storage/rabbitmq
chmod 777 -R storage/media storage/caddy_config storage/caddy_data storage/postgres storage/redis storage/rabbitmq

docker-compose up -d;
sleep 30s;