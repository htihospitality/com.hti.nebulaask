#!/bin/bash

export AWS_ACCESS_KEY_ID=$AWS_CREDENTIALS_ACCESS
export AWS_SECRET_ACCESS_KEY=$AWS_CREDENTIALS_SECRET
export AWS_DEFAULT_REGION=$AWS_REGION

apt update
apt ugrade -Y

apt install -y nodejs npm
#echo "Node Version:"
#node -v
#echo "npm Version:"
#npm -v
echo "installing yarn"
npm install yarn --force
echo "yarn version:"
yarn -v

#../bin/build

