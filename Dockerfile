FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl default-jre-headless curl git

RUN curl -O https://mirrors.aliyun.com/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz
RUN tar xf hadoop-2.9.2.tar.gz -C /usr/local

ENV JAVA_HOME /usr/lib/jvm/default-java                                          
ENV LD_LIBRARY_PATH $JAVA_HOME/lib/server:$LD_LIBRARY_PATH
ENV HADOOP_HOME /usr/local/hadoop-2.9.2
ENV LIBRARY_PATH $HADOOP_HOME/lib/native:$LIBRARY_PATH
ENV LD_LIBRARY_PATH $HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
ENV CLASSPATH $($HADOOP_HOME/bin/hadoop classpath --glob):$CLASSPATH

RUN git clone --recursive https://github.com/alibaba/euler.git
RUN apt-get install -y python python-pip && pip install tensorflow

RUN apt-get install -y ant autoconf build-essential cmake golang-go python-setuptools
RUN cd euler && \
    mkdir -p build && cd build \
    cmake .. \
    make -j 32 \
    cd .. \
    python tools/pip/setup.py install
