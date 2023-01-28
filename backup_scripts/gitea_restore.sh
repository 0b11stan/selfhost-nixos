RHOST=192.168.122.111
BACKUP_FILE=gitea-dump-1673190790.zip

# TODO : test it all
# TODO : put everything in a single file

TMP_DIR=$(ssh $RHOST mktemp -d)
scp ./gitea_restore_remote.sh $RHOST:$TMP_DIR
scp $BACKUP_FILE $RHOST:$TMP_DIR
ssh $RHOST chmod +x $TMP_DIR/gitea_restore_remote.sh
ssh $RHOST /bin/bash -c "cd $TMP_DIR && ./gitea_restore_remote.sh $TMP_DIR"
