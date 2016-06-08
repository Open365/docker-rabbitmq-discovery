#!/bin/sh

eyeos-service-ready-notify-cli &

sed -i 's/%RABBITMQ_AUTH_HOST%/'$RABBITMQ_AUTH_HOST'/g' ${RABBITMQ_CONFIG_FILE}.config
sed -i 's/%RABBITMQ_AUTH_PORT%/'$RABBITMQ_AUTH_PORT'/g' ${RABBITMQ_CONFIG_FILE}.config
sed -i 's/<<"eyeos">>/<<"'$RABBITMQ_GUEST_PASSWD'">>/g' ${RABBITMQ_CONFIG_FILE}.config

eyeos-run-server --serf rabbitmq-server
