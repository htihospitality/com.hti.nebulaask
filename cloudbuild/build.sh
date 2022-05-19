#!/bin/bash

mkdir ~/.aws
echo [default]  > ~/.aws/credentials
echo aws_access_key_id = $AWS_CREDENTIALS_ACCESS  >> ~/.aws/credentials
echo aws_secret_access_key = $AWS_CREDENTIALS_SECRET  >> ~/.aws/credentials

echo $AWS_CONFIG > ~/.aws/config

cat ~/.aws/credentials

../bin/build
