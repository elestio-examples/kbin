pwd=$(pwd)

cp $pwd/docker/v2/* $pwd

rm docker-compose.override.yml
rm docker-compose.prod.yml
rm docker-compose.yml

# sed -i "s~--link ~~g" ./Dockerfile
# sed -i "s~COPY package-lock.json \$KBIN_HOME~# COPY package-lock.json \$KBIN_HOME~g" ./Dockerfile
sed -i "s~COPY --chmod=755 docker/v2/docker-entrypoint ./~COPY docker/v2/docker-entrypoint ./~g" ./Dockerfile
# sed -i "s~COPY composer.* \$KBIN_HOME~COPY composer.* \$KBIN_HOME/~g" ./Dockerfile

# chmod 755 ./docker-entrypoint

docker build . --tag elestio4test/kbin:latest
docker buildx build . --tag elestio4test/kbin:latest --output type=local

# cp $pwd/docker/v2/Dockerfile $pwd
# sed -i "s~COPY package-lock.json \$KBIN_HOME~# COPY package-lock.json \$KBIN_HOME~g" ./Dockerfile