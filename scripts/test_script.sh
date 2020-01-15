#!/bin/bash
mysqladmin ping -h0.0.0.0
aws_install_loc=$(which aws)
if [ "$aws_install_loc" != '/usr/bin/aws' ]
then
echo 'AWS CLI is not installed'
exit 1;
else
echo 'All our test looks great!'
exit 0;
fi