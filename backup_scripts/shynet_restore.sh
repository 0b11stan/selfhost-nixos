RHOST=192.168.122.111
BACKUP_FILE=shynet-db-1673199653.sqlite3

CTR_NAME=$(ssh $RHOST docker ps -qf 'name=shynet')
TMP_DIR=$(ssh $RHOST mktemp -d)
scp $BACKUP_FILE $RHOST:$TMP_DIR
ssh $RHOST docker cp -a $TMP_DIR/$BACKUP_FILE $CTR_NAME:/var/local/shynet/db/db.sqlite3
ssh $RHOST docker exec -u root $CTR_NAME chown 500:500 /var/local/shynet/db/db.sqlite3
