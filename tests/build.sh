pwd=$(pwd)

cp $pwd/docker/v2/* $pwd

sed -i "s~--link ~~g" ./Dockerfile
sed -i "s~COPY --chmod=755  ./docker/v2/docker-entrypoint ./~COPY  docker/v2/docker-entrypoint ./~g" ./Dockerfile
sed -i "s~COPY composer.* \$KBIN_HOME~COPY composer.* \$KBIN_HOME/~g" ./Dockerfile

chmod 755 ./docker-entrypoint

docker build . --tag elestio4test/kbin:latest