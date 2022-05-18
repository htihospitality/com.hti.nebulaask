#!/bin/bash

touch ~/.aws/credentials
echo $AWS_CREDENTIALS > ~/.aws/credentials

../bin/build
