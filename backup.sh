#!/usr/bin/env bash

GRAFANA_BACKUP_BUCKET=$GRAFANA_BACKUP_BUCKET
GRAFANA_TOKEN=$GRAFANA_TOKEN
GRAFANA_URL=$GRAFANA_URL
GRAFANA_ADMIN_ACCOUNT=$GRAFANA_ADMIN_ACCOUNT
GRAFANA_ADMIN_PASSWORD=$GRAFANA_ADMIN_PASSWORD
VERIFY_SSL=$VERIFY_SSL

echo "running grafana backup"


grafana-backup save
if [ $? -eq 0 ]; then
	echo 'SUCCESS'
	ls -l /opt/grafana-backup-tool/

	echo "_OUTPUT_ dir"
	ls -l /opt/grafana-backup-tool/_OUTPUT_/

	gsutil ls
	# gsutil cp /opt/grafana-backup-tool/_OUTPUT_/*.tar gs://$GRAFANA_BACKUP_BUCKET/
else
	echo 'FAILED'
fi

