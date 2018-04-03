FROM alpine:3.7 as native
MAINTAINER craig@craigrueda.com

ENV JAVA_HOME=/usr/lib/jvm/default-jvm \
  TOMCAT_VERSION="8.5.29" \
  APR_VERSION="1.6.3-r0" \
  OPEN_SSL_VERSION="1.0.2o-r0" \
  OPEN_JDK_VERSION="8.151.12-r0"
ENV TOMCAT_BIN="https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

# Build tc-native
RUN apk add --no-cache apr-dev=${APR_VERSION} openssl-dev=${OPEN_SSL_VERSION} openjdk8=${OPEN_JDK_VERSION} wget unzip make g++ \
    && cd /tmp \
    && wget -O tomcat.tar.gz ${TOMCAT_BIN} \
    && tar -xvf tomcat.tar.gz \
    && cd apache-tomcat-*/bin \
    && tar -xvf tomcat-native.tar.gz \
    && cd tomcat-native-*/native \
    && ./configure --with-java-home=${JAVA_HOME} \
    && make \
    && make install

# Build the actual image now, copying over stuff from the base image as needed
FROM alpine:3.7
ENV APR_LIB=/usr/local/apr/lib \
  APR_VERSION="1.6.3-r0" \
  OPEN_SSL_VERSION="1.0.2o-r0" \
  OPEN_JDK_VERSION="8.151.12-r0" \
  JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=${PATH}:${JAVA_HOME}/bin

COPY --from=native ${APR_LIB} ${APR_LIB}

RUN apk add --no-cache apr=${APR_VERSION} openssl=${OPEN_SSL_VERSION} openjdk8-jre=${OPEN_JDK_VERSION}

CMD [ "sh" ]
