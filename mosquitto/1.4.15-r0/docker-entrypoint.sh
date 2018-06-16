#!/bin/ash

set -e

chown -R mosquitto:mosquitto /mosquitto

CONFIG=/mosquitto/config/mosquitto.conf

if [[ ! -z "${MOSQUITTO_PERSISTENCE}" ]]; then
    if [ $MOSQUITTO_PERSISTENCE == true ] || [ $MOSQUITTO_PERSISTENCE == false ]; then
        sed -r -i "s/(^#*)(persistence)\s+(.*)/\2 $(eval echo \$persistence $MOSQUITTO_PERSISTENCE|sed -e 's/\//\\\//g')/g" $CONFIG
    fi
fi

if [[ ! -z "${ALLOW_ANONYMOUS}" ]]; then
    if [ $ALLOW_ANONYMOUS == true ] || [ $ALLOW_ANONYMOUS == false ]; then
        sed -r -i "s/(^#*)(allow_anonymous)\s+(.*)/\2 $(eval echo \$allow_anonymous $ALLOW_ANONYMOUS|sed -e 's/\//\\\//g')/g" $CONFIG
    fi
fi

exec "$@"
