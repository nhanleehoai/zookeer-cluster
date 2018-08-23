FROM centos:7
MAINTAINER Nhan Le <nhanleehoai@yahoo.com>

ENV SHA1=8e2cc8784794e24df90fa1a9dbe6cd1695c79a44 \
	GPG_KEY=47792AD4 
	
ARG DISTRO_NAME=zookeeper-3.4.12

WORKDIR /tmp


RUN yum update -y && \
yum install wget net-tools telnet iproute traceroute -y && \
wget --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjre8-downloads-2133155.html; oraclelicense=accept-securebackup-cookie"  \
-q -O jre.rpm http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u181-linux-x64.rpm &&\
yum localinstall jre.rpm -y && \
wget -q "https://apache.org/dist/zookeeper/stable/$DISTRO_NAME.tar.gz" && \
wget -q "https://apache.org/dist/zookeeper/stable/$DISTRO_NAME.tar.gz.asc" && \
gpg --keyserver  hkp://p80.pool.sks-keyservers.net:80 --recv-key "$GPG_KEY" || \
gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" && \
gpg --verify $DISTRO_NAME.tar.gz.asc $DISTRO_NAME.tar.gz && \
echo "$SHA1  $DISTRO_NAME.tar.gz" | sha1sum -c && \
mkdir -p /opt/zookeeper && \
tar --strip-components 1 -xzf $DISTRO_NAME.tar.gz -C /opt/zookeeper &&\
rm -f zoo*.* && rm -f jre.rpm &&\
rm -rf /var/cache/yum

COPY zk-init.sh /opt/zookeeper/bin/
COPY log4j.properties /opt/zookeeper/conf/
RUN chmod +x /opt/zookeeper/bin/zk-init.sh
ENV PATH=$PATH:/opt/zookeeper/bin

ENTRYPOINT ["zk-init.sh"]
CMD ["zkServer.sh", "start-foreground"]


