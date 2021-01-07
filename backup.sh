#!/usr/bin/env bash

GRAFANA_BACKUP_BUCKET=$GRAFANA_BACKUP_BUCKET
GRAFANA_TOKEN=$GRAFANA_TOKEN
GRAFANA_URL=$GRAFANA_URL
GRAFANA_ADMIN_ACCOUNT=$GRAFANA_ADMIN_ACCOUNT
GRAFANA_ADMIN_PASSWORD=$GRAFANA_ADMIN_PASSWORD
VERIFY_SSL=$VERIFY_SSL

grafana-backup save
if [ $? -eq 0 ]; then
	echo 'SUCCESS'
	ls -l /opt/grafana-backup-tool/
else
	echo 'FAILED'
fi