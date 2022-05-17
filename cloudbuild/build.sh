#!/bin/bash

echo $MAVEN_SETTINGS > ~/.m2/settings.xml

echo @hti-ui:registry=https://europe-west1-npm.pkg.dev/hti-build/hti-npm/ > ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:_password=$GOOGLE_ARTIFACT_PASSWORD >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:username=_json_key_base64 >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:email=not.valid@email.com >> ~/.npmrc
echo //europe-west1-npm.pkg.dev/hti-build/hti-npm/:always-auth=true >> ~/.npmrc

../bin/build
