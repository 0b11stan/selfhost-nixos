RHOST=192.168.1.100
BACKUP_FILE=gitea-dump-1673190790.zip

set -e # exit if one command fail

# TODO : test it all
# TODO : put everything in a single file

TMP_DIR=$(ssh $RHOST mktemp -d)
echo "created tmp dir : $TMP_DIR"

echo "uploading restore script to remote host ..."
scp ../backup_scripts/gitea_restore_remote.sh $RHOST:$TMP_DIR

echo "uploading local backup to remote host ..."
scp $BACKUP_FILE $RHOST:$TMP_DIR

echo "executing the restore script ..."
ssh $RHOST chmod +x $TMP_DIR/gitea_restore_remote.sh
ssh $RHOST /bin/sh -c "'cd $TMP_DIR && ./gitea_restore_remote.sh $TMP_DIR'"
