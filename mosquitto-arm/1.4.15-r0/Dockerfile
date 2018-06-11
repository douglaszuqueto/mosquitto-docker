FROM alpine

LABEL maintainer="douglas.zuqueto@gmail.com"

EXPOSE 1883 8083

WORKDIR /mosquitto

VOLUME ["/mosquitto/config", "/mosquitto/data", "/mosquitto/log"]

COPY mosquitto.conf /mosquitto/config/
COPY docker-entrypoint.sh /

RUN apk update && \
    chmod +x /docker-entrypoint.sh && \
    mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    apk add mosquitto=1.4.15-r0 && \
    cp /etc/mosquitto/mosquitto.conf /mosquitto/config && \
    chown -R mosquitto:mosquitto /mosquitto && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
