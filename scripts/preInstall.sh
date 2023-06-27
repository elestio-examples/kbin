#set env vars
#set -o allexport; source .env; set +o allexport;


mkdir -p storage/media storage/caddy_condig storage/caddy_data
chown 1000:82 storage/media storage/caddy_condig storage/caddy_data