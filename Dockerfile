FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apt-transport-https curl lsb-core
RUN echo "deb https://kong.bintray.com/kong-deb `lsb_release -sc` main" | tee -a /etc/apt/sources.list

RUN curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray

RUN apt-key add bintray.key
RUN apt-get update && apt-get install -y kong

COPY kong.conf /etc/kong/kong.conf
ENTRYPOINT ["kong","migrations", "bootstrap", "-c", "/etc/kong/kong.conf"]