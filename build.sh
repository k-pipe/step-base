#!/bin/sh
USER=kpipe
IMAGE_NAME=step-base
#-alpine
if ["$1" = ""]
then
   IMAGE_TAG=alpine
else
  IMAGE_TAG=alpine-$1
fi
IMAGE=$USER/$IMAGE_NAME:$IMAGE_TAG
echo "===================================================================="
echo "  Building docker image $IMAGE"
echo "===================================================================="
docker pull kpipe/step-wrapper
docker build . -t $IMAGE --platform linux/amd64
echo "===================================================================="
echo "  Logging in to dockerhub with user $USER"
echo "===================================================================="
docker login --username $USER --password $DOCKERHUB_PUSH_TOKEN
echo "===================================================================="
echo "  Pushing image $IMAGE_ID"
echo "===================================================================="
docker push $IMAGE
echo "Done"