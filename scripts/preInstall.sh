#set env vars
#set -o allexport; source .env; set +o allexport;


mkdir -p storage/media storage/caddy_config storage/caddy_data storage/postgres storage/redis storage/rabbitmq
chmod 777 -R storage/media storage/caddy_config storage/caddy_data storage/postgres storage/redis storage/rabbitmq