#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

# Create new user (without email verification)
docker-compose exec -T php bin/console kbin:user:create admin ${ADMIN_EMAIL} ${ADMIN_PASSWORD}
# Grant administrator privileges
docker-compose exec -T php bin/console kbin:user:admin admin

docker-compose exec -T php bin/console kbin:ap:keys:update
