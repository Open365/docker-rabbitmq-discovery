FROM rabbitmq:3.6
MAINTAINER eyeos

ENV WHATAMI rabbit
ENV DISCOVERY_HOSTS_FILE_PATH /etc/hosts

ENV EYEOS_RABBIT_COOKIE 1234 # FIXME: vHanda: NOT USED

ENV RABBITMQ_AUTH_HOST localhost
ENV RABBITMQ_AUTH_PORT 7108

RUN \
    apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_0.10 | bash - && \
    apt-get install -y build-essential nodejs git net-tools dnsmasq unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN \
    npm install -g eyeos-run-server eyeos-tags-to-dns eyeos-service-ready-notify-cli && \
    npm cache clean && \
    curl -L https://releases.hashicorp.com/serf/0.6.4/serf_0.6.4_linux_amd64.zip -o serf.zip && unzip serf.zip && mv serf /usr/bin/serf

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY rabbitmq.config /etc/rabbitmq/rabbitmq.config
COPY start.sh /tmp/start.sh
COPY rabbitmq_auth_backend_http-3.6.x-3dfe5950.ez /usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins/

RUN rabbitmq-plugins enable rabbitmq_stomp && \
    rabbitmq-plugins enable rabbitmq_management && \
    rabbitmq-plugins enable rabbitmq_web_stomp && \
    rabbitmq-plugins enable rabbitmq_auth_backend_http

EXPOSE 5672 15672 15672 61613

CMD /tmp/start.sh
