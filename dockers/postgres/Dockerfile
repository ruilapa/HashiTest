FROM postgres:9.5
MAINTAINER Rui Lapa <rui.lapa@ruilapa.net>

ENV MY_USER mine
ENV MY_PASS allmine
ENV MY_DB   mordor
 
COPY scripts/create_user.sh /docker-entrypoint-initdb.d/create_user.sh
RUN chmod 755 /docker-entrypoint-initdb.d/create_user.sh
