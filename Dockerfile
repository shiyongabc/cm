FROM httpd:alpine


VOLUME ["/opt/cloudera/parcel-repo"]
VOLUME ["/opt/cloudera/rpm"]

RUN CM_VER=5.10.0 && MYSQL_VER=5.1.47 && apk --update add --no-cache wget curl && mkdir -p /rpm && cd /rpm \
 && wget -t 10  --retry-connrefused -O "cloudera-manager-centos7.tar.gz" https://archive.cloudera.com/cm5/cm/5/cloudera-manager-centos7-cm${CM_VER}_x86_64.tar.gz  \
 && wget -t 10  --retry-connrefused https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-${MYSQL_VER}.tar.gz \
 && tar zxf mysql-connector-java-${MYSQL_VER}.tar.gz && mv -f mysql-connector-java-${MYSQL_VER}/mysql-connector-java-${MYSQL_VER}-bin.jar ./mysql-connector-java.jar &&rm -rf mysql-connector-java-${MYSQL_VER} mysql-connector-java-${MYSQL_VER}.tar.gz \
 && curl  -o jdk8.rpm --insecure --junk-session-cookies --location --remote-name --silent --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.rpm \
 && apk del curl
 
 

RUN CDH_VER=5.10.0 && mkdir -p /parcel && cd /parcel \
 && wget -t 10  --retry-connrefused http://archive.cloudera.com/cdh5/parcels/${CDH_VER}/CDH-${CDH_VER}-1.cdh${CDH_VER}.p0.41-el7.parcel  \
 && wget -t 10  --retry-connrefused http://archive.cloudera.com/cdh5/parcels/${CDH_VER}/CDH-${CDH_VER}-1.cdh${CDH_VER}.p0.41-el7.parcel.sha1  \
 && wget -t 10  --retry-connrefused http://archive.cloudera.com/cdh5/parcels/${CDH_VER}/manifest.json  \
 
 && apk del wget
 
CMD cp -R -f /rpm/* /opt/cloudera/rpm/  && cp -R -f /parcel/* /opt/cloudera/parcel-repo/
