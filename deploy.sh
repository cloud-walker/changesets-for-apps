#!/bin/sh
set -e
set -x

ENV=${1:?"ENV (1st param) is missing"}
NAME=$(jq -r .name package.json)
VERSION=$(jq -r .version package.json)
HASH=$(git rev-parse --short HEAD)

if [ "$ENV" = "staging" ]; then
  TAG=cloudwalker/changesets-for-apps:$VERSION-$HASH
  docker build --tag "$TAG" .
  docker push "$TAG"
fi;

if [ "$ENV" = "production" ]; then
  TAG=cloudwalker/changesets-for-apps:$VERSION
  docker build --tag "$TAG" .
  docker push "$TAG"
fi;