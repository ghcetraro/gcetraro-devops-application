#!/bin/bash

#creo namespace
kubectl apply -f namespace-moni.yaml

#deployo influxdb
cd influxdb
kubectl apply -f influxdb-pvc.yaml
kubectl apply -f influxdb-config.yaml
kubectl apply -f influxdb-secrets.yaml
kubectl apply -f influxdb-deployment.yaml
kubectl apply -f influxdb-service.yaml
cd ..

#deployo telegraf
cd telegraf
kubectl apply -f telegraf-configmap.yaml
kubectl apply -f telegraf-secrets.yaml
kubectl apply -f telegraf-daemonset.yaml
cd ..

#deployo grafana
cd grafana
kubectl apply -f grafana-pvc.yaml
kubectl apply -f alpine-copy.yaml
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
cd ..

#publico grafana por el load balance
kubectl -n moni patch svc grafana-service -p '{"spec": {"type": "LoadBalancer"}}'
