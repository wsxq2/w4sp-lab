#build off of w4sp base image
FROM w4sp/labs:base

COPY elasticsearch-2.4.6.deb /tmp/elasticsearch-2.4.6.deb
RUN cd /tmp && dpkg -i elasticsearch-2.4.6.deb

#RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#RUN echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
#
#RUN apt-get update -q

RUN apt-get update && apt-get -y install default-jre-headless

#ENV KIBANA_VERSION 4.4.1 
#
#RUN cd /tmp && \
#	export https_proxy=http://192.168.56.100:1081 && \
#    wget -nv https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz && \
#	unset https_proxy && \
#    tar zxf kibana-${KIBANA_VERSION}-linux-x64.tar.gz && \
#    rm -f kibana-${KIBANA_VERSION}-linux-x64.tar.gz && \
#    mv /tmp/kibana-${KIBANA_VERSION}-linux-x64 /kibana

COPY kibana-4.4.1-linux-x64.tar.gz /tmp/kibana-4.4.1-linux-x64.tar.gz

RUN cd /tmp && tar zxf kibana-4.4.1-linux-x64.tar.gz && mv kibana-4.4.1-linux-x64 /kibana

RUN echo 'network.host: 0.0.0.0' >> /etc/elasticsearch/elasticsearch.yml

#add supervisor conf to start kibana and es
ADD supervisor_elk.conf /etc/supervisor/conf.d/supervisor_elk.conf
