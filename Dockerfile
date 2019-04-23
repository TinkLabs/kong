FROM ubuntu:16.04

RUN mkdir /app && mkdir /usr/local/kong/logs -p

RUN touch /usr/local/kong/logs/access.log && touch /usr/local/kong/logs/error.log

COPY kong.conf /etc/kong/kong.conf

RUN ln -sf /dev/stdout /usr/local/kong/logs/access.log && ln -sf /dev/stderr /usr/local/kong/logs/error.log

RUN apt-get update && apt-get install -y openssl libpcre3 procps perl curl wget

RUN cd /app && wget https://bintray.com/kong/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-1.1.0.xenial.all.deb

RUN dpkg -i /app/download_file?file_path=dists%2Fkong-community-edition-1.1.0.xenial.all.deb
ENTRYPOINT ["kong","start",","-c","/etc/kong/kong.conf"]