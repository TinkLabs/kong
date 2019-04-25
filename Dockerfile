FROM centos:7.2.1511
RUN yum update –y && yum install -y wget psmisc
RUN wget https://github.com/Kong/kong/releases/download/0.10.3/kong-0.10.3.el7.noarch.rpm
RUN rpm --rebuilddb && yum install -y kong-0.10.3.el7.noarch.rpm
RUN cp /usr/lib64/libpcre.so.1 /usr/lib64/libpcre.so.0
COPY kong.conf /etc/kong/kong.conf
ENTRYPOINT ["kong","start",","-c","/etc/kong/kong.conf"]
