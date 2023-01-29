RHOST=192.168.1.100
BACKUP_FILE=shynet-db-1674839347.sqlite3

CTR_NAME=$(ssh $RHOST docker ps -qf 'name=shynet')
echo "found container for shynet : $CTR_NAME"

TMP_DIR=$(ssh $RHOST mktemp -d)
echo "created tmp dir : $TMP_DIR"

echo "uploading local backup to remote ..."
scp $BACKUP_FILE $RHOST:$TMP_DIR

echo "restoring $TMP_DIR/$BACKUP_FILE on $CTR_NAME ..."
ssh $RHOST docker run --rm --volumes-from $CTR_NAME --volume $TMP_DIR:/backup \
  alpine cp /backup/$BACKUP_FILE /var/local/shynet/db/db.sqlite3
ssh $RHOST docker exec -u root $CTR_NAME chown 500:500 /var/local/shynet/db/db.sqlite3
