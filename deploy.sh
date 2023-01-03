#!/bin/sh

ENV=${1:?"ENV (1st param) is missing"}
NAME=$(jq -r .name package.json)
VERSION=$(jq -r .version package.json)
HASH=$(git rev-parse --short HEAD)

image_exists()
{
  return $(docker manifest inspect $1 > /dev/null ; echo $?)
}

if [ "$ENV" = "staging" ]; then
  IMAGE=lucabarone/changesets-for-apps:$VERSION-$HASH
  echo "IMAGE: $IMAGE"
  
  if image_exists "$IMAGE"; then
    echo "image $IMAGE already exists in the registry, skipping."
  else
    echo "image $IMAGE not found in the registry, pushing..."
    docker build --tag "$IMAGE" .
    docker push "$IMAGE"
  fi;
fi;

if [ "$ENV" = "production" ]; then
  IMAGE=lucabarone/changesets-for-apps:$VERSION

  if image_exists "$IMAGE"; then
    echo "image $IMAGE already exists in the registry, skipping."
  else
    echo "image $IMAGE not found in the registry, pushing..."
    docker build --tag "$IMAGE" .
    docker push "$IMAGE"
  fi;
fi;