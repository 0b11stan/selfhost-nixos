RHOST=192.168.1.133

CTR_NAME=$(ssh $RHOST docker ps -qf 'name=shynet')
TMP_DIR=$(ssh $RHOST mktemp -d)
ssh $RHOST docker cp $CTR_NAME:/var/local/shynet/db/db.sqlite3 $TMP_DIR
scp $RHOST:$TMP_DIR/db.sqlite3 shynet-db-$(date +%s).sqlite3
