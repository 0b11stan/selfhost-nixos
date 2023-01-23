RHOST=192.168.122.111
BACKUP_FILE=pwndoc-1674500350.zip

CTR_NAME=$(ssh $RHOST docker ps -qf 'name=pwndoc')
TMP_DIR=$(ssh $RHOST mktemp -d)
scp $BACKUP_FILE $RHOST:$TMP_DIR
ssh $RHOST docker cp 
