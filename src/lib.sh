#!/bin/bash

function log() { local message="$1"; local currentlog="$2";
	echo "$message" | tee -a "$currentlog";
}

function getDateTimeNow() { local result=$1;
	eval $result="'$(date +"%F %R:%S")'";
}

function dateToDateForFolder() { local input="$1"; local result=$2;
	eval $result="'$(date --date "$input" +"%F_%H-%M-%S")'";
}

function addTime() { local date="$1"; local add="$2"; local result=$3;
	local onlydate=$(date --date "$date" +"%F");
	local onlyhours=$(date --date "$date" +"%H");
	local onlyminutes=$(date --date "$date" +"%M");
	local onlyseconds=$(date --date "$date" +"%S");

	eval $result="'$(date --date "$onlydate + $onlyhours hours + $onlyminutes minutes + $onlyseconds seconds $add" +"%F %R:%S")'";
}

function findLastestBackup() { local currentlog="$1"; local selfreferenced="$2"; local targetroot="$3"; local source="$4"; local backupprefix="$5"; local result=$6;
	if [ "$selfreferenced" == true ]
	then
		log "Backup will be self-referenced." "$currentlog";
		eval $result="'$source'";
	else
		local latestbackup=$(ls -F "$targetroot" | grep "$backupprefix.*/" | sort -r | head -1);
		if [ -z "$latestbackup" ]
		then
			log "No previous backup found." "$currentlog";
		else
			log "Found previous backup \"$targetroot$latestbackup\"." "$currentlog";
			eval $result="'$targetroot$latestbackup'";
		fi
	fi
}

function backup() { local currentlog="$1"; local source="$2"; local targetroot="$3"; local backupprefix="$4"; local latestbackuptarget="$5"; local runningsuffix="$6"; local result=$7; local result2=$8;
	log "" "$currentlog";
	log "Starting backup for \"$source\" ..." "$currentlog";
	log "" "$currentlog";

	local currenttarget="$targetroot$backupprefix$runningsuffix";

	log "'$(rsync --delete --stats -PSvahHAXx \
		"$source" \
		--link-dest="$latestbackuptarget" \
		"$currenttarget")'" "$currentlog";

	getDateTimeNow datefinished;
	dateToDateForFolder "$datefinished" datefinishedformatted;

	local finishedbackupfolder="$targetroot$backupprefix$datefinishedformatted";
	mv "$currenttarget" "$finishedbackupfolder";
	log "" "$currentlog";
	log "Stored finished backup in \"$finishedbackupfolder\"." "$currentlog";

	eval $result="'$datefinished'";
	eval $result2="'$datefinishedformatted'";
}

function deleteoldbackups() { local currentlog="$1"; local datefinished="$2"; local targetroot="$3"; local backupprefix="$4"; local deletebackupsolderthan="$5";
	addTime "$datefinished" "$deletebackupsolderthan" datetodelete;

	if [[ "$datetodelete" < "$datefinished" ]]
	then
		dateToDateForFolder "$datetodelete" datetodeleteformatted;

		log "" "$currentlog";
		log "Deleting backups older than \"$datetodelete\" ..." "$currentlog";

		ls "$targetroot" | grep "$backupprefix.*" | while read line; do if [[ "$line" < "$backupprefix$datetodeleteformatted" ]]; then
			rm -r "$targetroot$line";
			log "Deleted \"$targetroot$line\"." "$currentlog";
		fi; done;

		log "" "$currentlog";
		log "Deletion of older backups finished." "$currentlog";
	else
		log "" "$currentlog";
		log "Did not delete old backups, because \"$datetodelete\" is not earlier than \"$datefinished\". Change \"\$deletebackupsolderthan\" to delete old backups." "$currentlog";
	fi;
}

function startBackup() { local logdestination="$1"; local backupprefix="$2"; local selfreferenced="$3"; local targetroot="$4"; local source="$5"; local deletebackupsolderthan="$6";
	local logsuffix=".log";
	local runningsuffix="running";
	local currentlog="$logdestination$backupprefix$runningsuffix$logsuffix";

	getDateTimeNow datestarted;
	log "Started backup at \"$datestarted\"." "$currentlog";
	log "" "$currentlog";

	findLastestBackup "$currentlog" "$selfreferenced" "$targetroot" "$source" "$backupprefix" latestbackuptarget;

	backup "$currentlog" "$source" "$targetroot" "$backupprefix" "$latestbackuptarget" "$runningsuffix" datefinished datefinishedformatted;

	deleteoldbackups "$currentlog" "$datefinished" "$targetroot" "$backupprefix" "$deletebackupsolderthan";

	local finishedlogfile="$logdestination$backupprefix$datefinishedformatted$logsuffix";
	mv "$currentlog" "$finishedlogfile";
	currentlog="$finishedlogfile";
	log "" "$currentlog";
	log "Stored finished log in \"$finishedlogfile\"." "$currentlog";

	getDateTimeNow finaltime;
	log "" "$currentlog";
	log "Backup process completed at \"$finaltime\"." "$currentlog";
}

