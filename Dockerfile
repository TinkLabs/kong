FROM ubuntu:16.04
RUN apt-get update && apt-get install openssl libpcre3 procps perl
RUN dpkg -i kong-community-edition-1.1.0.*.deb
ENTRYPOINT ["kong","start",","kong.conf"]
