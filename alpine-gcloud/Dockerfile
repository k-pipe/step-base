# use official gcloud image as build image
FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:432.0.0-alpine AS build

# remove unneeded stuff
RUN rm /google-cloud-sdk/bin/anthoscli

# matching python version to the one in google cloud...
FROM python:3.10.11-alpine

# copy gcloud cli to target image
COPY --from=build google-cloud-sdk /google-cloud-sdk

# copy wrapper and build utils
COPY --from=kpipe/step-base-alpine:latest /bin/step-wrapper /bin/resolve /bin/resolve-build-script  /bin/
COPY --from=kpipe/step-base-alpine:latest /template/build.sh /template/

# setup environment variables
ENV PATH=/google-cloud-sdk/bin:$PATH
ENV CLOUD_SDK_VERSION=432.0.0
