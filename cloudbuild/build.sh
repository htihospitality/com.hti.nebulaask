#!/bin/bash

echo $MAVEN_SETTINGS > ~/.m2/settings.xml

./bin/build
