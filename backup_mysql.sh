#!/bin/bash -
	 
	#######################
	#MySQL Hot Backup of InnoDB tables
	#Version: 1.0
	#Created: 2014-11-19
	#Author:PhongLe
	#Copyright (C) 2014  http://congdonglinux.vn
	########################
	 
	##Check if current user is root
	if [ $USER != "root" ]; then
        echo "You need to run this script as root."
        echo "Use 'sudo `basename $0`' then enter your password when prompted."
        exit 1
	fi
	
	##Get current time, path,
	NOW=`date +%Y%m%d%H%M%S`
	PWD=`pwd`
	HERE=`dirname $0`
	if [[ ${HERE:0:1} == "." ]]; then
    	HERE=$PWD/${HERE:1}
	fi
	
	## Database name you need backup
	DBS="mysql"
	
	## Password
	MYSQL_ROOT_PSW="password"
	
	##Backup dir
	BACKUP_DIR="/backup/database"
	TMP_DIR="/tmp"

	IMAGE_NAME="mysql_fullbackup_$NOW"
	TMP_BKUP_DIR=$TMP_DIR/$IMAGE_NAME
	mkdir $TMP_BKUP_DIR
	
	##command backup
	for DB in $DBS
	do
    	echo "SET SQL_LOG_BIN = 0;" > $TMP_BKUP_DIR/$DB.sql
    	mysqldump $DB -uroot -p$MYSQL_ROOT_PSW --add-drop-database --add-drop-table --create-options  --single-transaction --flush-logs --routines --master-data=2 >> $TMP_BKUP_DIR/$DB.sql
	done
	cd $TMP_DIR; tar -zcvf $BACKUP_DIR/$IMAGE_NAME.tar.gz $IMAGE_NAME*; cd $PWD
	rm -rf $TMP_BKUP_DIR

	echo DONE
	exit 0

