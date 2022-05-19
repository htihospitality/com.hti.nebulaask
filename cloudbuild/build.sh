#!/bin/bash

mkdir ~/.aws
echo $AWS_CREDENTIALS > ~/.aws/credentials
echo $AWS_CONFIG > ~/.aws/config

cat ~/.aws/config

../bin/build
