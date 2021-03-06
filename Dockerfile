FROM alpine:latest
LABEL maintainer="ysde108@gmail.com"

ENV RESTORE false
ENV ARCHIVE_FILE ""

RUN apk update

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk --no-cache add python3 py3-pip py3-cffi py3-cryptography ca-certificates bash curl

WORKDIR /tmp
RUN curl \
	https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-323.0.0-linux-x86_64.tar.gz \
	-o /tmp/google-cloud-sdk.tar.gz
RUN tar -zxf /tmp/google-cloud-sdk.tar.gz
ENV PATH="/tmp/google-cloud-sdk/bin:${PATH}"

WORKDIR /opt/grafana-backup-tool
ADD . /opt/grafana-backup-tool
RUN pip3 --no-cache-dir install .
ENV PATH $PATH:/opt/grafana-backup-tool
RUN echo "PATH=$PATH"

CMD sh -c 'if [ "$RESTORE" = true ]; then if [ ! -z "$AWS_S3_BUCKET_NAME" ]; then grafana-backup restore $ARCHIVE_FILE; else grafana-backup restore _OUTPUT_/$ARCHIVE_FILE; fi else grafana-backup save; fi'

