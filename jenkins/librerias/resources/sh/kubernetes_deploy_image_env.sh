#!/bin/bash

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

APPNAME=$(cat $WORKSPACE/sh/app_name.txt)
TAG=$(cat $WORKSPACE/sh/github_tag.txt)
#
function replace_pod() {
  sed -i s/%REGISTRY%/$registry_url/g $WORKSPACE/sh/pod.yaml
  sed -i s/%APPNAME%/$APPNAME/g $WORKSPACE/sh/pod.yaml
  sed -i s/%NEXUSKEY%/$registry_cred/g $WORKSPACE/sh/pod.yaml
  sed -i s/%NAMESPACE%/$namespace/g $WORKSPACE/sh/pod.yaml
  sed -i s/%TAG%/$TAG/g $WORKSPACE/sh/pod.yaml
  sed -i s/%PORT%/$dockerfile_port/g $WORKSPACE/sh/pod.yaml
  sed -i s/%REPLICA%/$replica/g $WORKSPACE/sh/pod.yaml
}
#
function replace_service() {
  sed -i s/%APPNAME%/$APPNAME/g $WORKSPACE/sh/service.yaml
  sed -i s/%NAMESPACE%/$namespace/g $WORKSPACE/sh/service.yaml
  sed -i s/%PORT%/$dockerfile_port/g $WORKSPACE/sh/service.yaml
}
###########################
set_debug
replace_pod
replace_service

if [ $(cat $FLAG) == "1" ]; then
  cat $WORKSPACE/sh/pod.yaml
  echo "--------------------------"
  cat $WORKSPACE/sh/service.yaml
fi

SERVICE_EXIST=$(kubectl get service -n $namespace | grep $APPNAME)

if [[ -n $SERVICE_EXIST ]]; then
  kubectl delete service $APPNAME -n $namespace
  sleep 5
fi

POD_EXIST=$(kubectl get deployment -n $namespace | grep $APPNAME)

if [[ -n $POD_EXIST ]]; then
  kubectl delete deployment $APPNAME -n $namespace
  sleep 5
fi

CONFIGMAP_EXIST=$(kubectl get configmap -n $namespace | grep $APPNAME)

if [[ -n $CONFIGMAP_EXIST ]]; then
  kubectl delete configmap $APPNAME -n $namespace
  sleep 5
fi

kubectl create configmap $APPNAME --from-file=$WORKSPACE/sh/config.map -n $namespace
sleep 10
kubectl apply -f $WORKSPACE/sh/pod.yaml
sleep 10
kubectl apply -f $WORKSPACE/sh/service.yaml
