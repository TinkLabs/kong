FROM ubuntu:16.04
RUN apt-get update -y && apt-get install -y openssl libpcre3 procps perl curl
RUN curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | sudo apt-key add -
RUN apt-get install -y kong-community-edition
#RUN dpkg -i kong-community-edition-1.1.0.*.deb
ENTRYPOINT ["kong","start",","kong.conf"]
