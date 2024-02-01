# use official gcloud image as build image
FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:432.0.0 AS build

# remove unneeded stuff
RUN rm /google-cloud-sdk/bin/anthoscli

# build target from alpine base image
FROM kpipe/step-base-alpine:latest

# copy gcloud cli to target image
COPY --from=build google-cloud-sdk /google-cloud-sdk

# setup environment variables
ENV PATH=/google-cloud-sdk/bin:$PATH
ENV CLOUD_SDK_VERSION=432.0.0
