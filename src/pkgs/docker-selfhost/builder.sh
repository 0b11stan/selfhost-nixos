export PATH="$coreutils/bin:$gnused/bin:$buildkit"

mkdir $out
echo "DOCKER_BUILDKIT=0 $docker/bin/docker compose --project-name '$name' --file '$src/docker-compose.yml' up --build" > $out/start.sh
echo "DOCKER_BUILDKIT=0 $docker/bin/docker compose --project-name '$name' --file '$src/docker-compose.yml' up -d --build" > $out/reload.sh
echo "DOCKER_BUILDKIT=0 $docker/bin/docker compose --project-name '$name' --file '$src/docker-compose.yml' down" > $out/stop.sh
chmod +x $out/*.sh
