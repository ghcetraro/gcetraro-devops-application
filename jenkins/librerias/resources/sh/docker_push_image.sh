#!/bin/bash

#### varaibles definidas
FLAG="sh/debug_mode.txt"

#habilito el debbug
#habilito el debbug
function set_debug() {
  if [[ -e $WORKSPACE/$FLAG ]]; then
    if [[ $(cat $FLAG) == "1" ]]; then
      echo "debug mode on"
      set -x
      debug_mode="1"
    else
      debug_mode="0"
    fi
  else
    debug_mode="0"
  fi
}

set_debug

IMAGE=$(cat $WORKSPACE/sh/docker_image.txt)

if [[ $debug_mode == "1" ]]; then
  cat $WORKSPACE/sh/docker_image.txt
fi

docker push $IMAGE > $WORKSPACE/sh/output_file.txt 2>&1

if [ $? -eq 0 ]; then
  echo "Se pudo enviar la imagen $IMAGE a la registry"
  if [ $debug_mode == "1" ]; then
    cat $WORKSPACE/sh/output_file.txt
  fi
else
  echo "No se pudo enviar la imagen $IMAGE a la registry"
  if [ $debug_mode == "1" ]; then
    cat $WORKSPACE/sh/output_file.txt
  fi
  exit 1
fi
