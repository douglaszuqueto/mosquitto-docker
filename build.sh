#!/usr/bin/env bash

docker build -t mosquitto-test . --no-cache

docker images mosquitto-test

docker run -it --rm --name mosquitto-test -p 1883:1883 -p 8083:8083 mosquitto-test
