FROM alpine:latest

RUN apk update > /dev/null
RUN apk add --no-cache --virtual .build-deps > /dev/null && \
    apk add bash > /dev/null

RUN apk -Uuv add groff less python py-pip > /dev/null && \
    pip install awscli > /dev/null && \
    apk add mysql-client > /dev/null && \
    apk --purge -v del py-pip

RUN rm /var/cache/apk/*
WORKDIR /home

COPY scripts/db_backup.sh db_backup.sh
CMD ["bash", "db_backup.sh"]