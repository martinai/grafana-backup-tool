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

	gsutil cp /opt/grafana-backup-tool/_OUTPUT_/*.tar.gz gs://$GRAFANA_BACKUP_BUCKET/
	if [ $? -eq 0 ]; then
		# Webhook to Slack if gsutil fails
		curl -X POST -H 'Content-type: application/json' --data '{"text":"Grafana backup tool failed because gsutil was not able to upload to the bucket correctly."}' https://hooks.slack.com/services/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
		exit 1;
	fi
else
	echo 'FAILED'
	# Webhook to Slack if gsutil fails
    curl -X POST -H 'Content-type: application/json' --data '{"text":"Grafana backup tool failed because the grafana-backup save command failed."}' https://hooks.slack.com/services/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
    exit 1;
fi

