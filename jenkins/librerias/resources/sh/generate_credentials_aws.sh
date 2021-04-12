#!/bin/bash

#### input
USER=$1
PASSWORD=$2

#### varaibles definidas
FLAG="sh/debug_mode.txt"

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
#####################################################################
function aws_forder() {
  if [ -d ~/.aws ]; then
    rm -fr ~/.aws
    mkdir -p ~/.aws
  else
    mkdir -p ~/.aws
  fi
}

function aws_get_credentials() {
  echo '[default]' > ~/.aws/credentials
  echo "aws_access_key_id = $USER" >> ~/.aws/credentials
  echo "aws_secret_access_key = $PASSWORD" >> ~/.aws/credentials
}

function aws_get_profile() {
  echo '[default]' > ~/.aws/config
  echo \'region = $registry_zone\' >> ~/.aws/config
  echo 'output = json' >> ~/.aws/config
}

########################## main #######################
if [ $# -ge '2' ]; then
  set_debug
  aws_forder
  aws_get_profile
  aws_get_credentials
else
  echo "Uso: $0 <USER> <PASSWORD>"
  exit 1
fi
