#!/bin/bash
# This script tags the current staging image for production and pushes it to the 
# configured docker repository. After this, it connects to the production server
# via ssh and pulls the image there. Finally, the running container is recreated.

set -euo pipefail
IMAGE=tmde
SERVER=thorsten-michael.de
REGISTRY="docker.$SERVER"
DEPLOYMENT_PATH=/var/www/thorsten-michael.de
DEPLOYMENT_SERVICE=$IMAGE
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

# Login to production server via ssh to pull the updated image and recreate the running container
ssh $SSH_ARGS 'bash -s' <<-STDIN && success "recreate production container for $DEPLOYMENT_SERVICE on $SERVER" || fail "recreate production container for $DEPLOYMENT_SERVICE on $SERVER"
  set -euo pipefail
  cd $DEPLOYMENT_PATH
  docker compose pull $DEPLOYMENT_SERVICE
  docker compose up -d $DEPLOYMENT_SERVICE
STDIN

 

