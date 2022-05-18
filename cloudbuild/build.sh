#!/bin/bash

mkdir ~/.aws
echo $AWS_CREDENTIALS > ~/.aws/credentials

../bin/build
