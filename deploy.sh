#!/bin/sh

ENV=${1:?"ENV (1st param) is missing"}
NAME=$(jq -r .name package.json)
VERSION=$(jq -r .version package.json)
HASH=$(git rev-parse --short HEAD)

image_exists()
{
  docker manifest inspect $1 > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo false
  else
    echo true
  fi
}

image_deploy()
{
  if [ $(image_exists $1) = true ]; then
    echo "image $IMAGE already exists in the registry, skipping."
  else
    echo "image $IMAGE not found in the registry, pushing..."
    docker build --tag "$1" .
    docker push "$1"
  fi
}

if [ "$ENV" = "staging" ]; then
  IMAGE=lucabarone/$NAME:$VERSION-$HASH
  image_deploy $IMAGE
fi

if [ "$ENV" = "production" ]; then
  IMAGE=lucabarone/$NAME:$VERSION
  image_deploy $IMAGE
fi