#!/bin/bash

export AWS_ACCESS_KEY_ID=$AWS_CREDENTIALS_ACCESS
export AWS_SECRET_ACCESS_KEY=$AWS_CREDENTIALS_SECRET
export AWS_DEFAULT_REGION=$AWS_REGION

echo @hti-ui:registry=https://europe-west1-npm.pkg.dev/hti-build/hti-npm/ > ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:_password=$GOOGLE_ARTIFACT_PASSWORD >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:username=_json_key_base64 >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:email=not.valid@email.com >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:always-auth=true >> ~/.npmrc

apt update
apt ugrade -Y

apt install -y nodejs npm

npm install yarn --force


../bin/build

