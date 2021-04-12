#!/bin/bash

#creo namespace
kubectl apply -f namespace-moni.yaml

#deployo influxdb
cd influxdb
kubectl delete -f influxdb-pvc.yaml
kubectl delete -f influxdb-config.yaml
kubectl delete -f influxdb-secrets.yaml
kubectl delete -f influxdb-deployment.yaml
kubectl delete -f influxdb-service.yaml
cd ..

#deployo telegraf
cd telegraf
kubectl delete -f telegraf-configmap.yaml
kubectl delete -f telegraf-secrets.yaml
kubectl delete -f telegraf-daemonset.yaml
cd ..

#deployo grafana
cd grafana
kubectl delete -f grafana-pvc.yaml
kubectl delete -f alpine-copy.yaml
kubectl delete -f grafana-deployment.yaml
kubectl delete -f grafana-service.yaml
cd ..
