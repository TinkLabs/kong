FROM ubuntu:16.04
RUN mkdir /app
RUN apt-get update && apt-get install -y openssl libpcre3 procps perl curl wget
RUN cd /app && wget https://bintray.com/kong/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-1.1.0.xenial.all.deb
RUN dpkg -i /app/download_file?file_path=dists%2Fkong-community-edition-1.1.0.xenial.all.deb
ENTRYPOINT ["kong","start",","kong.conf"]
