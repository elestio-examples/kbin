pwd=$(pwd)

cp -R $pwd/docker/v2/* $pwd

rm docker-compose.override.yml
rm docker-compose.prod.yml
rm docker-compose.yml
sed -i "s~COPY package-lock.json \$KBIN_HOME~# COPY package-lock.json \$KBIN_HOME~g" ./Dockerfile
sed -i '/router.request_context.scheme: https/a \  asset.request_context.secure: true' ./config/services.yaml

docker buildx build . --output type=docker,name=elestio4test/kbin:latest | docker load
