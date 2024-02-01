#!/bin/sh
if [ "$1" = "" ]
then
   IMAGE_TAG=latest
else
  IMAGE_TAG=$1
fi
if [ "$DOCKER_COMMAND" = "" ]
then
   DOCKER_COMMAND=docker
fi
IMAGE={{registry}}/{{repository}}/{{image}}:$IMAGE_TAG
IMAGE_TMP=local-image
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
ADD {{added}} /
COPY --from=kpipe/step-wrapper /bin/step-wrapper /bin/
CMD step-wrapper {{wrapper-command}}
" > Dockerfile
$DOCKER_COMMAND build . $DOCKER_OPTIONS -t $IMAGE_TMP --platform={{platform}}
EXITCODE=$?
if [ $EXITCODE -ne 0 ]
then
   echo "Docker build failed (exit code: $EXITCODE)" 1>&2
   exit $EXITCODE
fi
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
      echo "Tests failed!" 1>&2
      exit 1
   fi
fi
echo ""
echo "========================"
echo "  Tagging docker image  "
echo "========================"
echo ""
echo "Tagging: $IMAGE_TMP --> $IMAGE"
$DOCKER_COMMAND $DOCKER_OPTIONS tag $IMAGE_TMP $IMAGE
echo ""
echo "========================"
echo "  Pushing docker image  "
echo "========================"
echo ""
echo "Image: $IMAGE"
$DOCKER_COMMAND push $DOCKER_OPTIONS $IMAGE
