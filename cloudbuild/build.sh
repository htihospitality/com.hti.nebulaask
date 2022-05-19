#!/bin/bash

#mkdir ~/.aws
#echo [default]  > ~/.aws/credentials
#echo aws_access_key_id = $AWS_CREDENTIALS_ACCESS  >> ~/.aws/credentials
#echo aws_secret_access_key = $AWS_CREDENTIALS_SECRET  >> ~/.aws/credentials

export AWS_ACCESS_KEY_ID=$AWS_CREDENTIALS_ACCESS
export AWS_SECRET_ACCESS_KEY=$AWS_CREDENTIALS_SECRET
export AWS_DEFAULT_REGION=$AWS_REGION

#echo $AWS_CONFIG > ~/.aws/config

#cat ~/.aws/credentials

../bin/build
