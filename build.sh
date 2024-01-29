#!/bin/sh
USER=kpipe
IMAGE_NAME=step-base-alpine
if ["$1" = ""]
then
   IMAGE_TAG=latest
else
  IMAGE_TAG=$1
fi
IMAGE=$USER/$IMAGE_NAME:$IMAGE_TAG
echo "===================================================================="
echo "  Building docker image $IMAGE"
echo "===================================================================="
docker build . -t $IMAGE
exit
echo "===================================================================="
echo "  Logging in to dockerhub with user $USER"
echo "===================================================================="
docker login --username $USER --password $DOCKERHUB_PUSH_TOKEN
echo "===================================================================="
echo "  Pushing image $IMAGE_ID"
echo "===================================================================="
docker push $IMAGE
echo "Done"