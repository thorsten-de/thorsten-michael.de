#!/bin/bash
# Builds the release image and tags it with :staging, so it can be tested locally
# and deployed in the production later

REGISTRY="docker.thorsten-michael.de"
IMAGE=tmde
DIR=`dirname "$(readlink -f "$0")"`

docker build -f $DIR/release/Dockerfile -t $REGISTRY/$IMAGE:staging $PWD
