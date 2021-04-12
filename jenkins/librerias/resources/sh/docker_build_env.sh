#!/bin/bash

#### input
NUMBER=$1

#### varaibles definidas
FLAG="$WORKSPACE/sh/debug_mode.txt"

#habilito el debbug
function set_debug() {
  if [ -e $FLAG ]; then
    if [ $(cat $FLAG) == "1" ]; then
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

GITHUB_TAG=$(< $WORKSPACE/sh/tag)

APP_NAME=$(pwd | tr -s '/' ' ' | awk '{print $NF}' | sed s/ms_//g | sed s/sr_//g | sed s/sg_//g | sed s/ic_//g | sed s/wd_//g)

DOCKER_IMAGE="$registry_url/$namespace/$APP_NAME:$GITHUB_TAG"

sed -i s/%REGISTRY%/$registry_url/g $WORKSPACE/Dockerfile
sed -i s/%PORT%/$dockerfile_port/g $WORKSPACE/Dockerfile

if [ $debug_mode == "1" ]; then
  cat $WORKSPACE/Dockerfile
  echo " "
fi

docker build --force-rm --rm -t "$DOCKER_IMAGE" .

if [ $? -eq 0 ]; then
  echo -e "Se pudo crear la imagen $DOCKER_IMAGE"
else
  echo "No se pudo crear la imagen $DOCKER_IMAGE"
  if [ debug_mode == "0" ]; then
    exit 1
  fi
fi

#
echo "$DOCKER_IMAGE" > $WORKSPACE/sh/docker_image.txt
echo "$APP_NAME" > $WORKSPACE/sh/app_name.txt
echo "$GITHUB_TAG" > $WORKSPACE/sh/github_tag.txt

echo 'env.GITHUB_TAG=''"'$GITHUB_TAG'"' > $WORKSPACE/sh/docker_load
