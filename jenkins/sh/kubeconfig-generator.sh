#!/bin/bash
#set -x
#jenkins-deploy-tool
USER='jenkins-admin'
NAMES='kube-system'

server="https://$1"

name=$(kubectl get serviceaccount $USER -n $NAMES -o jsonpath="{.secrets[0].name}")

ca=$(kubectl get secret/$name -o jsonpath='{.data.ca\.crt}' -n $NAMES)
token=$(kubectl get secret/$name -o jsonpath='{.data.token}' -n $NAMES | base64 --decode)
namespace=$(kubectl get secret/$name -o jsonpath='{.data.namespace}' -n $NAMES | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > test.kubeconfig
