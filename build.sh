#!/bin/sh
USER=kpipe
IMAGE_NAME=step-base
if [ "$GITHUB_REF_NAME" = "main" ]
then
   IMAGE_TAG=latest
else
  IMAGE_TAG=$GITHUB_REF_NAME
fi
IMAGE=$USER/$IMAGE_NAME:$IMAGE_TAG
echo "===================================================================="
echo "  Building docker image $IMAGE"
echo "===================================================================="
#docker pull kpipe/step-wrapper
docker build . -t $IMAGE --platform linux/amd64
if [ $? -ne 0 ]
then
   exit 1
fi
echo "===================================================================="
echo "  Logging in to dockerhub with user $USER"
echo "===================================================================="
docker login --username $USER --password $DOCKERHUB_PUSH_TOKEN
if [ $? -ne 0 ]
then
   exit 1
fi
echo "===================================================================="
echo "  Pushing image $IMAGE_ID"
echo "===================================================================="
docker push $IMAGE
if [ $? -ne 0 ]
then
   exit 1
fi
echo "Done"