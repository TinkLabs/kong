FROM centos:7.2.1511

RUN yum update -y && yum install -y wget
RUN wget https://bintray.com/kong/kong-rpm/rpm -O bintray-kong-kong-rpm.repo
RUN export major_version=`grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release | cut -d "." -f1`
RUN sed -i -e 's/baseurl.*/&\/centos\/'$major_version''/ bintray-kong-kong-rpm.repo
RUN mv bintray-kong-kong-rpm.repo /etc/yum.repos.d/
RUN yum update -y && yum install -y kong

COPY kong.conf /etc/kong/kong.conf
ENTRYPOINT ["kong","migrations", "bootstrap", "-c", "/etc/kong/kong.conf"]