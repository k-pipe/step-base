FROM alpine:latest
COPY --from=kpipe/step-wrapper:latest /bin/step-wrapper /bin/
ADD template/ /template/
ADD scripts/ /scripts/
ADD scripts/resolve scripts/resolve-build-script /bin/
ENTRYPOINT ["resolve-build-script"]