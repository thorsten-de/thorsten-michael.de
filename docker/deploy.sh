#!/bin/bash

set -euo pipefail
SERVER=thorsten-michael.de
DEPLOYMENT_PATH=/var/www/thorsten-michael.de
REGISTRY="docker.$SERVER"
IMAGE=tmde
SSH_OPTIONS="-o StrictHostKeyChecking=no"
SSH_ARGS="$SERVER $SSH_OPTIONS"

success () {
  echo "$1 successful."
}

fail () {
  echo "$1 failed."
  exit 1
}

echo $PATH
# Tag current staging image for production and push it to the repository
docker tag $REGISTRY/$IMAGE:staging $REGISTRY/$IMAGE:prod
docker push $REGISTRY/$IMAGE:prod
success "production image push to $REGISTRY"

ssh $SSH_ARGS 'bash -s' <<-STDIN && success "recreate production container" || fail "recreate production container"
  set -euo pipefail
  cd $DEPLOYMENT_PATH
  docker compose pull tmde
  docker compose up -d tmde
STDIN

 

