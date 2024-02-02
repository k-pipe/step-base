FROM alpine:latest
COPY --from=kpipe/step-wrapper:latest /bin/step-wrapper /bin/
ADD template/ /template/
ADD scripts/* /bin/
CMD resolve-build-script