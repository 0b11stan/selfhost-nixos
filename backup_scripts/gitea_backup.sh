RHOST=192.168.1.133

CTR_NAME=$(ssh $RHOST docker ps -qf 'name=gitea')

TMP_DIR=$(ssh $RHOST mktemp -d)

ssh $RHOST docker exec --interactive --tty \
  --user git --workdir /tmp $CTR_NAME \
  bash -c '/usr/local/bin/gitea dump -c /data/gitea/conf/app.ini'

EXPORT_FILE=$(ssh $RHOST docker exec $CTR_NAME \
  /bin/bash -c 'ls -t /tmp/*.zip')

ssh $RHOST docker cp $CTR_NAME:/tmp/$EXPORT_FILE $TMP_DIR
scp -r $RHOST:$TMP_DIR .
