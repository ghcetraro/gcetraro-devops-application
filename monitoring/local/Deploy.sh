#!/bin/bash
#
#version necesario de docker-compose
#
echo "Activo docker swarm"
docker swarm init

echo "Creo las carpeta"
sudo mkdir -p /data/swarm/data/telegraf
sudo mkdir -p /data/swarm/data/influxdb
sudo mkdir -p /data/swarm/data/chronograf
sudo mkdir -p /data/swarm/data/grafana
#
echo "Copio configuraciones"
sudo cp telegraf.conf /data/swarm/data/telegraf/
#
echo "Genero permisos necesarios"
sudo chmod -R 777 /data/swarm/data
#
echo "Creo la network local"
docker network create --driver=overlay --attachable core-infra
#
echo "Deployo agente"
docker stack deploy --compose-file monitor_agentes.yml monitor_agentes
#
echo "Deployo monitor"
docker stack deploy --compose-file monitor_influx_grafana.yml monitor_influx_grafana
#
echo "Listo containers"
docker ps | grep monitor_
