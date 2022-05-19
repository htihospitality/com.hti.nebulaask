#!/bin/bash

mkdir ~/.aws
echo $AWS_CREDENTIALS | tr '_-' '/+' | base64 -d > ~/.aws/credentials
echo $AWS_CONFIG | tr '_-' '/+' | base64 -d > ~/.aws/config

cat ~/.aws/config

../bin/build
