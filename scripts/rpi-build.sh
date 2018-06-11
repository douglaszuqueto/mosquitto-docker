#!/usr/bin/env bash

cd

# Download do projeto
rm -rf mosquitto-docker
git clone https://github.com/douglaszuqueto/mosquitto-docker
cd mosquitto-docker
chmod +x build.sh

# Build
./build.sh