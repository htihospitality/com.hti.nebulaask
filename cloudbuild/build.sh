#!/bin/bash

export AWS_ACCESS_KEY_ID=$AWS_CREDENTIALS_ACCESS
export AWS_SECRET_ACCESS_KEY=$AWS_CREDENTIALS_SECRET
export AWS_DEFAULT_REGION=$AWS_REGION


apt install nodejs npm
node -v
npm install yarn
yarn -v

#../bin/build
