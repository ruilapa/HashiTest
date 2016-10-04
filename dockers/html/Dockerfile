FROM debian:jessie
MAINTAINER Rui Lapa <rui.lapa@ruilapa.net>

COPY site/ /var/www/html

RUN chown -R www-data:www-data /var/www/html

VOLUME ["/var/www/html"]

ENTRYPOINT /usr/bin/tail -f /dev/null
