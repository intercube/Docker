ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/intercube/Docker" \
      org.opencontainers.image.description="Intercube PHP CLI build image with FTP support"

RUN install-php-extensions ftp
