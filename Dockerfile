FROM centos:7.2.1511
RUN yum update –y && yum install -y wget
RUN wget https://github.com/Mashape/kong/releases/download/0.10.1/kong-0.10.1.aws.rpm
RUN rpm --rebuilddb && yum install -y kong-0.10.1.aws.rpm
RUN cp /etc/kong/kong.conf.default /etc/kong/kong.conf
COPY kong.conf /etc/kong/kong.conf
ENTRYPOINT ["kong","start",","-c","/etc/kong/kong.conf"]
