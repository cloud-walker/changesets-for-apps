#!/bin/sh
set -e
# set -x

ENV=${1:?"ENV (1st param) is missing"}
NAME=$(jq -r .name package.json)
VERSION=$(jq -r .version package.json)
HASH=$(git rev-parse --short HEAD)

if [ "$ENV" = "staging" ]; then
  TAG=lucabarone/changesets-for-apps:$VERSION-$HASH
  EXISTS=$(docker manifest inspect $TAG > /dev/null; echo $?)
  
  if [ $EXISTS -eq 0 ]; then
    echo "image $TAG already exists in the registry, skipping."
  else
    echo "image $TAG not found in the registry, pushing..."
    docker build --tag "$TAG" .
    docker push "$TAG"
  fi;
fi;

if [ "$ENV" = "production" ]; then
  TAG=lucabarone/changesets-for-apps:$VERSION
  EXISTS=$(docker manifest inspect $TAG > /dev/null; echo $?)

  if [ $EXISTS -eq 0 ]; then
    echo "image $TAG already exists in the registry, skipping."
  else
    echo "image $TAG not found in the registry, pushing..."
    docker build --tag "$TAG" .
    docker push "$TAG"
  fi;
fi;