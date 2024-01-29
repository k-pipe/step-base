FROM alpine:latest
ADD template/ /template/
ADD scripts/ /scripts/
ADD scripts/resolve scripts/resolve-build-script /bin/
ENTRYPOINT ["resolve-build-script"]