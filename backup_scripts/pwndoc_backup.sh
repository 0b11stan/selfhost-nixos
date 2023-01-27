RHOST=192.168.1.133

CTR_DATABASE=$(ssh $RHOST docker ps -qf 'name=pwndoc-database')
CTR_TEMPLATE=$(ssh $RHOST docker ps -qf 'name=pwndoc-backend')

TMP_DIR=$(ssh $RHOST mktemp -d)

backup() {
  CTR=$1; SRC=$2; DST=$3
  ssh $RHOST docker run --rm --volumes-from $CTR --volume $TMP_DIR:/backup \
    alpine tar czf /backup/$DST -C $SRC .
}

backup $CTR_DATABASE /data/db pwndoc-database-$(date +%s).tar.gz
backup $CTR_TEMPLATE /app/report-templates pwndoc-template-$(date +%s).tar.gz
scp -r $RHOST:$TMP_DIR/ .
