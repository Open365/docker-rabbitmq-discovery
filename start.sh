#!/usr/bin/env bash

eyeos-service-ready-notify-cli &

sed -i 's/%RABBITMQ_AUTH_HOST%/'$RABBITMQ_AUTH_HOST'/g' /etc/rabbitmq/rabbitmq.config
sed -i 's/%RABBITMQ_AUTH_PORT%/'$RABBITMQ_AUTH_PORT'/g' /etc/rabbitmq/rabbitmq.config
sed -i 's/<<"eyeos">>/<<"'$RABBITMQ_GUEST_PASSWD'">>/g' /etc/rabbitmq/rabbitmq.config

eyeos-run-server --serf rabbitmq-server
