#!/bin/bash

mkdir ~/.aws
echo $AWS_CREDENTIALS > ~/.aws/credentials
echo $AWS_CONFIG > ~/.aws/config

../bin/build
