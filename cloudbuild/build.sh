#!/bin/bash

echo $AWS_CREDENTIALS > ~/.aws/credentials

../bin/build
