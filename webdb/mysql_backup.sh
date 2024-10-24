#!/bin/bash
# 
#  this script will backup all MYSQL databases the specified user has access to
# - possibility to specify excluded tables so your backups will stay compact (defaults for TYPO3)
# - backups can be removed after a custom-defined time
# 
# modify these parameters:

DEST="/var/wiener"		# backup destination directory
 
MyUSER="weiner"    			# MySQL username  ------ FOR SECURITY REASONS THIS USER SHOULD HAVE READ-ONLY ACCESS to all DBs! ----
MyPASS="Password1"         # MySQL password
MyHOST="localhost"          # DB hostname

MAXAGE=60 								  # max AGE in DAYS for backup-files

EXCLUDED_TABLES=(
be_sessions
cache_treelist
cf_cache_hash
cf_cache_hash_tags
cf_cache_imagesizes
cf_cache_imagesizes_tags
cf_cache_pages
cf_cache_pagesection
cf_cache_pagesection_tags
cf_cache_pages_tags
cf_cache_rootline
cf_cache_rootline_tags
cf_extbase_datamapfactory_datamap
cf_extbase_datamapfactory_datamap_tags
cf_extbase_object
cf_extbase_object_tags
cf_extbase_reflection
cf_extbase_reflection_tags
cf_static_file_cache
cf_static_file_cache_tags
cf_tx_cal_cache
cf_tx_cal_cache_tags
fe_session_data
fe_sessions
tx_extensionmanager_domain_model_extension
)

#### DO NOT MODIFY BEYOND THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING! ###
############################################################################

# directory where backups will be stored:
MBD="$DEST"
 
# get hostname:
HOST="$(hostname)"

# file for current db backup file:
FILE=""

# list of databases:
DBS=""
 
# DO NOT BACKUP these databases:
SKIPSCHEMES="information_schema performance_schema"
 
[ ! -d $MBD ] && mkdir -p $MBD || :

 
# Get all database list first
DBS="$(/var/lib/mysql -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"
 
for db in $DBS
do

	# build the ignored-tables string:
	IGNORED_TABLES_STRING=''
	for TABLE in "${EXCLUDED_TABLES[@]}"
	do
   		IGNORED_TABLES_STRING+=" --ignore-table=${db}.${TABLE}"
	done

    # date in dd-mm-yyyy format:
    NOW="$(date +"%Y-%m-%d-%H%M")"
    
    skipdb=-1
    if [ "$SKIPSCHEMES" != "" ];
    then
    for i in $SKIPSCHEMES
    do
        [ "$db" == "$i" ] && skipdb=1 || :
    done
    fi
 
    if [ "$skipdb" == "-1" ] ; then
    FILE="$MBD/$NOW-$db.sql.gz"
    # connect to mysql using mysqldump for current mysql database
    # pipe it out to gz file in backup dir
        /usr/local/bin/mysqldump -u $MyUSER -h $MyHOST -p$MyPASS --single-transaction --quick --skip-lock-tables --max_allowed_packet=512M $db ${IGNORED_TABLES_STRING} | gzip -9 > $FILE
    fi
done


# remove backups older than X days:
find $MBD -mtime +$MAXAGE -exec rm '{}' \;
