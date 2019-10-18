FROM alpine:latest

LABEL maintainer="Jeroen Ketelaar"

RUN apk add --update nginx
RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*

ADD config/nginx.conf /etc/nginx/
ADD config/website.conf /etc/nginx/conf.d/
RUN rm -rf /etc/nginx/conf.d/default.conf

RUN echo "upstream php-upstream { server php:9001; }" > /etc/nginx/conf.d/upstream.conf

RUN adduser -D -g '' -G www-data www-data

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
