export PATH="$coreutils/bin:$gnused/bin:$buildkit"

mkdir $out
echo "DOCKER_BUILDKIT=0 $docker/bin/docker compose --project-name '$name' --file '$src/docker-compose.yml' up -d --build" > $out/$name.sh
chmod +x $out/$name.sh

