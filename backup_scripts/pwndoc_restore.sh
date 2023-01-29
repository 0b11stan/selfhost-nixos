RHOST=192.168.1.100
BACKUP_TEMPLATE=pwndoc-template-1674807195.tar.gz
BACKUP_DATABASE=pwndoc-database-1674807126.tar.gz

restore() {
  VOL=$1 SRC=$2
  echo "restoring $SRC on $VOL ..."
  ssh $RHOST docker run --rm --volume $VOL:/mnt --volume $TMP_DIR:/backup \
    alpine "/bin/sh -c 'cd /mnt && rm -r * && tar xzf /backup/$SRC --strip 2'"
}

VOL_DATABASE=$(ssh $RHOST docker volume ls -qf name=pwndoc_mongodb)
VOL_TEMPLATE=$(ssh $RHOST docker volume ls -qf name=pwndoc_templates)
echo "found volume for database : $VOL_DATABASE"
echo "found volume for template : $VOL_TEMPLATE"

TMP_DIR=$(ssh $RHOST mktemp -d)
echo "created tmp dir : $TMP_DIR"

echo "uploading local backup to remote ..."
scp $BACKUP_TEMPLATE $RHOST:$TMP_DIR/
scp $BACKUP_DATABASE $RHOST:$TMP_DIR/

restore $VOL_TEMPLATE $BACKUP_TEMPLATE
restore $VOL_DATABASE $BACKUP_DATABASE
