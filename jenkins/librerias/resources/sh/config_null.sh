#!/bin/bash

#### input
ID_ENV=$1
WORKSPACE=$2

#### varaibles definidas
FLAG="$WORKSPACE/sh/debug_mode.txt"

####varibles globales
PREREQUISITOS='2'

#######################################obligatorios en todo script #####################################
#habilito el debbug
function set_debug() {
  if [[ -e $WORKSPACE/$FLAG ]]; then
    if [[ $(cat $WORKSPACE/$FLAG) == "1" ]]; then
      echo "debug mode on"
      set -x
    fi
  fi
}
#### verifica prerequisitos para inicar script
function prerequisites() {
  if [ $# -ge $PREREQUISITOS ]; then
    echo "0"
  else
    echo "Uso: $0 <IDCOLA> <WORKSPACE>"
  fi
}
##############################################################################################################################
function verifico_configmap() {
  APP_NAME=$(pwd | tr -s '/' ' ' | awk '{print $NF}' | sed s/ms_//g | sed s/db_//g | sed s/sg_//g | sed s/jb_//g | sed s/zz_//g | sed s/sr_//g | sed s/wd_//g | sed s/ic_//g)
  VAR="$namespace"_"$APP_NAME"."map"

  #verifico si existe el config para el ambiente
  if [[ -e sh/cloud_config/$namespace/$VAR ]]; then
    echo "Existe el config.map de $VAR"
    cp $WORKSPACE/sh/cloud_config/$namespace/$VAR $WORKSPACE/sh/config.map
  else
    echo "No existe el config.map de $VAR"
    exit 1
  fi
}
#
function verifico_dockerfile() {
  if [[ -e $WORKSPACE/sh/Dockerfile ]]; then
    echo "Existe un Dockerfile en la carpeta que no deberia estar aqui"
    rm -fr $WORKSPACE/sh/Dockerfile
  fi
  if [[ -e $WORKSPACE/sh/dockerfile ]]; then
    echo "Existe un Dockerfile en la carpeta que no deberia estar aqui"
    rm -fr $WORKSPACE/sh/dockerfile
  fi
}
#
function verifico_config_local() {
  if [[ -e $WORKSPACE/sh/config.map ]]; then
    echo "Existe un config.map en la carpeta que no deberia estar aqui"
    rm -fr $WORKSPACE/sh/config.map
  fi
  if [[ -e $WORKSPACE/config.map ]]; then
    echo "Existe un config.map en la carpeta que no deberia estar aqui"
    rm -fr $WORKSPACE/config.map
  fi
}
############################################################################################################
function main() {
  set_debug
  verifico_dockerfile
  verifico_config_local
  #
  verifico_configmap
}

########################## main #######################
if [[ $(prerequisites $@) == "0" ]]; then
  main
else
  echo $(prerequisites $@)
fi
