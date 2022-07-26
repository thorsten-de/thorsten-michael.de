#!/bin/bash

REGISTRY="docker.thorsten-michael.de"
IMAGE=tmde
DIR=`dirname "$(readlink -f "$0")"`

docker build -f $DIR/release/Dockerfile -t $REGISTRY/$IMAGE:staging $PWD
