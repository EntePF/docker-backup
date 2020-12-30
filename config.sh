#!/bin/bash
. ./src/lib.sh

# if true hard links will point to $SOURCE, otherwise to latest previous backup
startBackup "/srv/docker-backup/logs/" \
	"Server Backup " \
	false \
	"/srv/docker-backup/" \
	"/srv/docker/" \
	"- 6 months";

echo;
startBackup "/srv/resilio-sync-backup/logs/" \
	"Server Backup " \
	true \
	"/srv/resilio-sync-backup/" \
	"/srv/resilio-sync/" \
	"- 6 months";

echo;
startBackup "/media/patrick/PF_4TB/backup/logs/" \
	"Docker_" \
	false \
	"/media/patrick/PF_4TB/backup/" \
	"/srv/docker/" \
	"- 6 months";

echo;
startBackup "/media/patrick/PF_4TB/backup/logs/" \
	"Resilio_Sync_" \
	false \
	"/media/patrick/PF_4TB/backup/" \
	"/srv/resilio-sync/" \
	"- 6 months";

echo;
startBackup "/media/patrick/PF_3TB/georg_resilio_backup/logs/" \
	"Georg_Resilio_Backup" \
	true \
	"/media/patrick/PF_3TB/georg_resilio_backup/" \
	"/media/patrick/PF_3TB/georg_resilio/" \
	"- 6 months";
