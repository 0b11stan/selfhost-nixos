BACKUP_FILE=gitea-dump-1673190790.zip
TMP_DIR=$1

CTR_NAME=$(docker ps -qf 'name=gitea')

docker cp $TMP_DIR/$BACKUP_FILE $CTR_NAME:/tmp/

docker exec $CTR_NAME mkdir /tmp/restore
docker exec $CTR_NAME unzip /tmp/$BACKUP_FILE -d /tmp/restore
docker exec $CTR_NAME bash -c 'ls -1 /tmp/restore/data/ | xargs -I{} mv -v /tmp/restore/data/{} /data/gitea/{}'
docker exec $CTR_NAME bash -c 'ls -1 /tmp/restore/repos/ | xargs -I{} mv -v /tmp/restore/repos/{} /data/git/repositories/{}'
docker exec $CTR_NAME bash -c 'chown -R git:git /data'
docker exec $CTR_NAME rm -r /tmp/restore
