BACKUP_FILE=gitea-dump-1673190790.zip
TMP_DIR=$1

CTR_NAME=$(docker ps -qf 'name=gitea')
echo "found container for gitea : $CTR_NAME"

echo "sending $TMP_DIR/$BACKUP_FILE to container $CTR_NAME's /tmp ..."
docker cp $TMP_DIR/$BACKUP_FILE $CTR_NAME:/tmp/

# TODO : use a throaway container (cf: https://docs.docker.com/storage/volumes/#back-up-restore-or-migrate-data-volumes)
# TODO : ( docker run -it --rm --volume docker-selfhost_gitea:/data --volume /tmp/tmp.Dd1BheC6I9:/backup --user git gitea/gitea /bin/bash )
# TODO : /usr/local/bin/gitea -c '/data/gitea/conf/app.ini' admin regenerate hooks

echo "$CTR_NAME: creating /tmp/restore ..."
docker exec $CTR_NAME mkdir /tmp/restore

echo "$CTR_NAME: unzipping /tmp/$BACKUP_FILE to /tmp/restore ..."
docker exec $CTR_NAME unzip /tmp/$BACKUP_FILE -d /tmp/restore

echo "$CTR_NAME: restoring database ..."
docker exec $CTR_NAME bash -c 'ls -1 /tmp/restore/data/ | xargs -I{} mv -v /tmp/restore/data/{} /data/gitea/{}'

echo "$CTR_NAME: restoring repositories ..."
docker exec $CTR_NAME bash -c 'ls -1 /tmp/restore/repos/ | xargs -I{} mv -v /tmp/restore/repos/{} /data/git/repositories/{}'

echo "$CTR_NAME: fixing rights ..."
docker exec $CTR_NAME bash -c 'chown -R git:git /data'

echo "$CTR_NAME: regenerate Git Hooks"
docker exec $CTR_NAME /usr/local/bin/gitea -c '/data/gitea/conf/app.ini' admin regenerate hooks

echo "$CTR_NAME: removing /tmp/restore ..."
docker exec $CTR_NAME rm -r /tmp/restore
