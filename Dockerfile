FROM ubuntu:16.04
RUN sudo apt-get update && sudo apt-get install openssl libpcre3 procps perl
RUN sudo dpkg -i kong-community-edition-1.1.0.*.deb
ENTRYPOINT ["kong","start",","kong.conf"]
