# Mosquitto - Docker(em desenvolvimento)

Imagem Docker para rodar o Broker MQTT Mosquitto

## Arquiteturas para implementar

* x64
* arm

## Versões para implementar

* mosquitto
* mosquitto-auth

## Rodando

```
docker run -it --rm -p 1883:1883 -p 8083:8083 mosquitto-test sh

# Utilizando environment
docker run -it --rm -p 1883:1883 -p 8083:8083 -e MOSQUITTO_PERSISTENCE=false mosquitto-test sh
```

## Environment

* MOSQUITTO_PERSISTENCE
## Referências

* [Mosquitto auth plugin](https://github.com/douglaszuqueto/mosquitto-auth-plugin)
* [ambientum](https://github.com/codecasts/ambientum)
