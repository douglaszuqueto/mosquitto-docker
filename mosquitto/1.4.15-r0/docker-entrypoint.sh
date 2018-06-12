#!/bin/ash

set -e

chown -R mosquitto:mosquitto /mosquitto

CONFIG=/mosquitto/config/mosquitto.conf

if [[ -v 'MOSQUITTO_PERSISTENCE' ]]; then
    if [ $MOSQUITTO_PERSISTENCE == true ] || [ $MOSQUITTO_PERSISTENCE == false ]; then
        sed -r -i "s/(^#*)(persistence)\s+(.*)/\2 $(eval echo \$persistence $MOSQUITTO_PERSISTENCE|sed -e 's/\//\\\//g')/g" $CONFIG
    fi
fi

exec "$@"
