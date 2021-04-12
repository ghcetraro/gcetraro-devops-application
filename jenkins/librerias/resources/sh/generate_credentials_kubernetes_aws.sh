#!/bin/bash

USER=$1
PASSWORD=$2

#### varaibles definidas
FLAG="$WORKSPACE/sh/debug_mode.txt"

#habilito el debbug
function set_debug() {
  if [ -e $FLAG ]; then
    if [ $(cat $FLAG) == "1" ]; then
      echo "debug mode on"
      set -x
    fi
  fi
}

set_debug

#
if [ -d ~/.kube ]; then
  rm -fr ~/.kube
  mkdir ~/.kube
  echo > ~/.kube/config
fi

aws eks --region $aws_region update-kubeconfig --name $aws_cluster
