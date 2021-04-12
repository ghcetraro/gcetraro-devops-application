#!/bin/bash

###variables de ambiente

#### varaibles definidas
FLAG="sh/debug_mode.txt"

#habilito el debbug
function set_debug() {
  if [ -e $WORKSPACE/$FLAG ]; then
    if [ $(cat $FLAG) == "1" ]; then
      echo "debug mode on"
      set -x
    fi
  fi
}

set_debug

if [ -d "~/.docker" ]; then
  rm -fr ~/.docker
  mkdir -p ~/.docker
  echo {} > ~/.docker/config.jso
else
  mkdir -p ~/.docker
  echo {} > ~/.docker/config.json
fi

docker logout $registry_url

sleep 3

TOKEN=$(aws ecr get-login-password --region $aws_region)

if [[ -n $TOKEN ]]; then
  echo "$TOKEN" | docker login --username AWS --password-stdin $registry_url
else
  echo "No se pudieron obtener las credenciales de docker para aws"
  exit 1
fi
