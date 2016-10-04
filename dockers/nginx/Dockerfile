FROM alpine:3.3
MAINTAINER Rui Lapa <rui.lapa@ruilapa.net>

RUN apk --update upgrade && \
    apk add \
    ca-certificates \
    curl \
    nginx && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

##############################
# NGINX

RUN mkdir -p /var/log/nginx
RUN touch /var/log/nginx/error.log
RUN touch /var/log/nginx/access.log

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /etc/nginx/conf.d

ADD run.sh /etc/nginx/run.sh
RUN chmod 755 /etc/nginx/run.sh

EXPOSE 80
EXPOSE 443

CMD ["/etc/nginx/run.sh"]
