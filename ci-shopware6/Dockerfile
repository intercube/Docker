FROM ubuntu:20.04

LABEL author="Intercube" maintainer="opensource@intercube.io"

ENV TZ='Europe/Amsterdam'

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN export USER=docker

RUN groupadd --non-unique --gid ${GROUPS[0]} $USER \
  || addgroup -gid ${GROUPS[0]} $USER
RUN useradd  --non-unique --gid ${GROUPS[0]} --uid $UID --create-home --home-dir /home/$USER --shell $SHELL $USER \
  || adduser -gid $USER -u $UID -h /home/$USER -s $SHELL -D $USER

RUN apt-get update
RUN apt-get install -y \
    apt-utils \
    autoconf \
    autogen \
    build-essential \
    curl \
    git \
    jq \
    libjpeg-dev \
    libpng-dev \
    libpng16-16 \
    language-pack-en-base \
    openssh-client \
    sudo \
    software-properties-common \
    ssh \
    telnet \
    unzip \
    wget \
    zip

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php7.4
RUN apt-get install -y \
    php7.4-curl \
    php7.4-gd \
    php7.4-dev \
    php7.4-xml \
    php7.4-bcmath \
    php7.4-mysql \
    php7.4-pgsql \
    php7.4-mbstring \
    php7.4-zip \
    php7.4-bz2 \
    php7.4-sqlite \
    php7.4-soap \
    php7.4-json \
    php7.4-intl \
    php7.4-imap \
    php7.4-imagick \
    php-memcached

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/* && \
    curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm@8 -g
