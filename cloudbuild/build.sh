#!/bin/bash

echo "Setting AWS environment variables"
export AWS_ACCESS_KEY_ID=$AWS_CREDENTIALS_ACCESS
export AWS_SECRET_ACCESS_KEY=$AWS_CREDENTIALS_SECRET
export AWS_DEFAULT_REGION=$AWS_REGION

echo "Setting npm creds"
echo @hti-ui:registry=https://europe-west1-npm.pkg.dev/hti-build/hti-npm/ > ~/.npmrc
echo @hti-auth:registry=https://europe-west1-npm.pkg.dev/hti-build/hti-npm/ >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:_password=$GOOGLE_ARTIFACT_PASSWORD >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:username=_json_key_base64 >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:email=not.valid@email.com >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:always-auth=true >> ~/.npmrc


echo "Starting update and upgrade"
apt update
apt ugrade -Y

echo "Installing Node"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs npm
echo "Node Version"
node -v

echo "Installing Yarn"
npm install yarn --global --force
echo "Yarn Version"
yarn -v
#echo "Running Yarn"
#yarn


echo "Starting build"
../bin/build

