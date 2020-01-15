#!/bin/bash

# mysql env checks
if ! mysql -h $MYSQL_HOST -u $USER  -e "SHOW DATABASES"; then
    echo 'MYSQL DB connection failed, Please check the credentials.'
    exit 1;
fi

#aws cli available
aws_install_loc=$(which aws)
if [ "$aws_install_loc" != '/usr/bin/aws' ]; then
    echo 'AWS CLI is not installed'
    exit 1;
else
    echo 'All our test looks great!'
    exit 0;
fi