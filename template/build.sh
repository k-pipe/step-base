#!/bin/sh
if ["$1" = ""]
then
   IMAGE_TAG=latest
else
  IMAGE_TAG=$1
fi
IMAGE={{registry}}/{{repository}}/{{image}}:$IMAGE_TAG
echo ""
echo "========================="
echo "  Building docker image  "
echo "========================="
echo ""
echo Image name: $IMAGE
echo Platform: {{platform}}
echo "
FROM {{base-image}}
RUN apk add --no-cache {{dependencies}}
ADD {{added-folders}} {{run-script}} /
COPY --from=kpipe/step-wrapper /bin/step-wrapper /bin/
ADD resolve resolve-and-run /bin/
# TODO use yaml instead of json extension
CMD resolve-and-run /workdir/input/config.json {{run-script}}
" > Dockerfile
docker build . -t $IMAGE --platform={{platform}}
echo ""
echo "=============================="
echo "  Authenticating to registry  "
echo "=============================="
echo ""
echo "Registry: {{registry}}"
USER=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
echo "User: $USER"
echo ""
echo "================="
echo "  Running tests  "
echo "================="
echo ""
if [ "{{test-script}}" = "" ]
then
   echo "No tests defined... Consider specifying a test command in build.yaml in order to test the created docker image automatically!"
else
   echo "Test script: {{test-script}}"
   ./{{test-script}}
   if [ $? = 0 ]
   then
      echo Tests succeeded
   else
      echo Tests failed! 1>&2
      exit 1
   fi
fi
echo ""
echo "========================"
echo "  Pushing docker image  "
echo "========================"
echo ""
echo "Image: $IMAGE"
docker push $IMAGE
