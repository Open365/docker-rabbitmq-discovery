FROM bashell/alpine-rmq:3.6.1
MAINTAINER eyeos

ENV WHATAMI rabbit
ENV DISCOVERY_HOSTS_FILE_PATH /etc/hosts
ENV WorkDir /var/service
WORKDIR ${WorkDir}
ENV RABBITMQ_HOME /srv/rabbitmq_server-${RABBITMQ_VERSION}
ENV RABBITMQ_CONFIG_FILE /etc/rabbitmq/rabbitmq
ENV RABBITMQ_AUTH_PORT 7108
ENV PATH ${PATH}:${RABBITMQ_HOME}/sbin/

RUN \
    apk update && \
    apk add curl make gcc g++ git python unzip dnsmasq net-tools nodejs

RUN \
    npm install -g eyeos-run-server eyeos-tags-to-dns eyeos-service-ready-notify-cli && \
    npm cache clean && \
    curl -L https://releases.hashicorp.com/serf/0.6.4/serf_0.6.4_linux_amd64.zip -o serf.zip && unzip serf.zip && mv serf /usr/bin/serf

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY rabbitmq.config ${RABBITMQ_CONFIG_FILE}.config
COPY start.sh ${WorkDir}/start.sh
COPY rabbitmq_auth_backend_http-3.6.x-3dfe5950.ez ${RABBITMQ_HOME}/plugins/

RUN rabbitmq-plugins enable rabbitmq_stomp --offline && \
    rabbitmq-plugins enable rabbitmq_management --offline && \
    rabbitmq-plugins enable rabbitmq_web_stomp --offline && \
    rabbitmq-plugins enable rabbitmq_auth_backend_http --offline && \
    apk del curl make gcc g++ git python unzip net-tools && \
    rm -r /etc/ssl /var/cache/apk/* /tmp/*

EXPOSE 5672 15671 15672 61613

CMD ["./start.sh"]
