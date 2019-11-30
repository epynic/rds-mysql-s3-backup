## RDS MYSQL AWS S3 Backup script

A simple containerised app to take daily mysql dumps and upload to your S3 bucket.

### Prerequisite 
* AWS User with Programmatic Access write to S3.
* AWS Access key ID and Secret access key.
* Valid MYSQL credentials. MYSQL_HOST can be a MYSQL RDS endpoint.
* Ofcource docker setup and running.
* MYSQL dumps will be uploaded in *s3://bucket_name/year/month/date/DB_NAME/mysql dump files here*
* MYSQL dumps are created table wise.


### Build Docker Image
```
docker build --no-cache -t=epynic/rds-mysql-s3-backup .
```

### Usage
```
docker container run \
    -e AWS_ACCESS_KEY_ID=AKXXXXXXXXXXXXX \
    -e AWS_SECRET_ACCESS_KEY=pSXXXXXXXXXXXXXX \
    -e S3_BUCKET='XXXXXXXXXXXXX' \
    -e MYSQL_HOST='mysql_endpoint' \
    -e MYSQL_PWD='mysql_password' \
    -e USER='mysql_username' \ 
    epynic/rds-mysql-s3-backup
```


#### CRON - Runs Daily
```
0 0 * * * docker container run -e AWS_ACCESS_KEY_ID=AKXXXXXXXXXXXXX -e AWS_SECRET_ACCESS_KEY=pSXXXXXXXXXXXXXX -e S3_BUCKET='XXXXXXXXXXXXX' -e MYSQL_HOST='mysql_endpoint' -e MYSQL_PWD='mysql_password' -e USER='mysql_username' -rm epynic/rds-mysql-s3-backup
```

##### :beer: