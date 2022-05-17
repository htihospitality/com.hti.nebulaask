#!/bin/bash

lein change repositories set "[[\"artifact-registry\" {:url \"artifactregistry://europe-west1-maven.pkg.dev/hti-build/hti-maven\" :username \"_json_key_base64\" :password \"$MAVEN_PASSWORD\"}]]"

lein with-profile prod ring uberjar