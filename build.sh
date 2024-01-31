#!/bin/sh
echo "Tag name from GITHUB_REF_NAME: $GITHUB_REF_NAME"
echo "Tag name from github.ref_name: ${{  github.ref_name }}"
USER=kpipe
IMAGE_NAME=step-base
#-alpine
if [ "$1" = "" ]
then
   IMAGE_TAG=alpine
else
  IMAGE_TAG=alpine-$1
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