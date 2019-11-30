#!/bin/bash
#check for ENV set or die
if [ -z "$MYSQL_HOST" -o -z "$MYSQL_PWD" -o -z "$USER" -o -z "$S3_BUCKET" -o -z "$AWS_SECRET_ACCESS_KEY" -o -z "$AWS_ACCESS_KEY_ID" ]; then
    echo >&2 'error: env variables are uninitialized or not specified '
	echo >&2 'You need to specify one of MYSQL_HOST, MYSQL_PWD, USER, S3_BUCKET, AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID' 
    exit 1
fi

# For DB get tables
# table - get schema + data dump gz
# / date / DB_NAME / schema / SCHEMA
# / date / DB_NAME / data / DATA
DATABASES=$(mysql -h $MYSQL_HOST -u $USER -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

TODAY=`date -I`
mkdir -p $TODAY

for db in $DATABASES; do
    mkdir -p "${TODAY}/${db}"
    echo "DB Schema ${db} to path: ${TODAY}/${db}/schema_${db}.sql.gz"
    mysqldump -h $MYSQL_HOST -u $USER --no-data $db | gzip > ${TODAY}/${db}/schema_${db}.sql.gz
    TABLES=$(mysql -h $MYSQL_HOST -u $USER -e "USE $db;SHOW TABLES;" | tr -d "| " | grep -v Tables_in_${db})
    # mysqldump -h $MYSQL_HOST -u $USER -u root -p --no-data dbname > schema.sql
    for table in $TABLES; do
        echo "Table $db $table to path: ${TODAY}/${db}/${table}.sql.gz"
        mysqldump -h $MYSQL_HOST -u $USER --single-transaction --quick --lock-tables=false $db $table | gzip > ${TODAY}/${db}/${table}.sql.gz
    done
    #S3 copy to drive
    S3DIRPATH=`date '+%Y/%m/%d'`
    aws s3 cp --recursive ${TODAY}/${db}/ s3://${S3_BUCKET}/${S3DIRPATH}/${db}/
    rm -rf ${TODAY}/${db}
done
rm -rf ${TODAY}
echo "Completed"