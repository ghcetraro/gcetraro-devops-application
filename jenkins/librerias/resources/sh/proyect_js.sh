#!/bin/bash

#### varaibles definidas
FLAG="$WORKSPACE/sh/debug_mode.txt"

#habilito el debbug
function set_debug() {
  if [[ -e $WORKSPACE/$FLAG ]]; then
    if [[ $(cat $WORKSPACE/$FLAG) == "1" ]]; then
      echo "debug mode on"
      set -x
    fi
  fi
}

set_debug

# Be0x83: se le da soporte a proyecto de tipo VUE.JS
if [[ -e "$WORKSPACE/vue.config.js" ]]; then
  echo "Es un proyecto de tipo VUE.JS, se procede a sobrescribir el archivo .env"
  rm -f $WORKSPACE/.env
  cp $WORKSPACE/sh/config.map $WORKSPACE/.env
fi
