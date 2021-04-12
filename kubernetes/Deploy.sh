#!/bin/bash
#
clear
#
REGISTRY="052965077586.dkr.ecr.us-east-1.amazonaws.com"
AWS_REGION="us-east-1"
#
function usage() {
  echo "Usage: $0 $@ "
  exit 1
}
#
while getopts ':n:r:p:c:d:f:h:' option; do
  case $option in
    n)
      NAMESPACE=$OPTARG
      ;;
    r)
      REPLICA=$OPTARG
      ;;
    p)
      PORTSERVICE=$OPTARG
      ;;
    c)
      FOLDER_CODE=$OPTARG
      ;;
    d)
      DELETE_SERVICE=$OPTARG
      ;;
    f)
      FILE_CONFIGMAP=$OPTARG
      ;;
    h)
      HPA=$OPTARG
      ;;
    *) #No hago nada con parametros que no conozco
      usage
      ;;
  esac
done
#
function prerequisites() {
  if [[ -z ${NAMESPACE+x} ]]; then
    usage -n NAMESPACE
  elif [[ -z ${REPLICA+x} ]]; then
    usage -r REPLICA
  elif [[ -z ${PORTSERVICE+x} ]]; then
    usage -p PORTSERVICE
  elif [[ -z ${FOLDER_CODE+x} ]]; then
    usage -c FOLDER_CODE
  elif [[ -z ${DELETE_SERVICE+x} ]]; then
    usage -d DELETE_SERVICE
  elif [[ -z ${FILE_CONFIGMAP} ]]; then
    usage -f FILE_CONFIGMAP
  elif [[ -z ${HPA} ]]; then
    usage -h HPA
  fi
}
#
function palet-colour() {
  #
  local COLOR="$1"
  #
  local BLACK='\033[0;30m'
  local RED='\033[0;31m'
  local GREEN='\033[0;32m'
  local BLUE='\033[0;34m'
  #
  COLOUR_END='\033[0m' # No Color
  #
  if [[ $COLOR == "red" ]]; then
    COLOUR_PALET="$RED"
  elif [[ $COLOR == "green" ]]; then
    COLOUR_PALET="$GREEN"
  elif [[ $COLOR == "black" ]]; then
    COLOUR_PALET="$BLACK"
  elif [[ $COLOR == "blue" ]]; then
    COLOUR_PALET="$BLUE"
  elif [[ $COLOR == "yellow" ]]; then
    COLOUR_PALET="$YELLOW"
  fi
}
#
function print-color() {
  local COLOR="$1"
  local TEXT=$MENSAJE
  #
  palet-colour $COLOR
  #
  echo -e "${COLOUR_PALET}$TEXT${COLOUR_END}"
  #
}
#
#
function buscar-version() {
  MENSAJE="Busco la version actual"
  palet-colour green
  VERSION=$(cat $FOLDER_CODE/version)
  MENSAJE="La version actual es $VERSION"
  print-color green
}
#
function compilar() {
  MENSAJE="Se empieza a compilar el codigo"
  print-color green
  REGISTRY_APP="$REGISTRY/$FOLDER_CODE:$VERSION"
  docker build -t "$REGISTRY_APP" $APPNAME > /dev/null 2>&1
}
#
function enviar() {
  MENSAJE="Verifico si la imagen se pudo crear bien"
  print-color blue
  if [[ -n $(docker images | grep $REGISTRY | grep $APPNAME | grep $VERSION) ]]; then
    MENSAJE="Envio la imagen $REGISTRY_APP a la registry remota de aws"
    print-color green
    docker push $REGISTRY_APP > /dev/null 2>&1
  else
    MENSAJE="No se pudo crear la imagen $REGISTRY_APP"
    print-color red
    exit 1
  fi
}
#
function preparo-yaml() {
  #creo lo nuevos archivos
  cp yaml/template.pod.yaml yaml/pod.yaml
  cp yaml/template.service.yaml yaml/service.yaml
  cp yaml/template.pod.autoscaler.yaml yaml/pod.autoscaler.yaml
  #
  local POD="yaml/pod.yaml"
  sed -i s,%APPNAME%,$APPNAME,g $POD
  sed -i s,%NAMESPACE%,$NAMESPACE,g $POD
  sed -i s,%REGISTRY%,$REGISTRY_APP,g $POD
  sed -i s,%PORT%,$PORTSERVICE,g $POD
  sed -i s,%REPLICA%,$REPLICA,g $POD
  #
  local PODAUTO="yaml/pod.autoscaler.yaml"
  sed -i s,%APPNAME%,$APPNAME,g $PODAUTO
  sed -i s,%NAMESPACE%,$NAMESPACE,g $PODAUTO
  local CRECIMIENTO="$REPLICA"
  let CRECIMIENTO=CRECIMIENTO+2
  sed -i s,%REPLICA%,$CRECIMIENTO,g $PODAUTO
  #
  local SERVICE="yaml/service.yaml"
  sed -i s,%APPNAME%,$APPNAME,g $SERVICE
  sed -i s,%NAMESPACE%,$NAMESPACE,g $SERVICE
  sed -i s,%PORT%,$PORTSERVICE,g $SERVICE
}
#
function deploy-config-map() {
  if [[ -e $APPNAME/code/$FILE_CONFIGMAP ]]; then

    CONFIGMAP_EXIST=$(kubectl get configmap -n $NAMESPACE | grep $APPNAME)
    if [[ -n $CONFIGMAP_EXIST ]]; then
      kubectl delete configmap $APPNAME -n $NAMESPACE
      sleep 5
    fi
    kubectl create configmap $APPNAME --from-file=$APPNAME/code/$FILE_CONFIGMAP -n $NAMESPACE
  else
    MENSAJE="No existe el configmap $FILE_CONFIGMAP, que se quiere cargar"
    print-color red
    exit 1
  fi
}
#
function deploy-kuberntes() {
  POD_EXIST=$(kubectl get deployment -n $NAMESPACE | grep $APPNAME)
  if [[ -n $POD_EXIST ]]; then
    kubectl delete deployment $APPNAME -n $NAMESPACE
    sleep 5
  fi
  #
  sleep 10
  kubectl apply -f yaml/pod.yaml
  sleep 10
}
#
function deploy-hpa() {
  if [[ $HPA == 'true' ]]; then
    MENSAJE="Configuro hpa"
    print-color green
    kubectl apply -f yaml/pod.autoscaler.yaml
  else
    MENSAJE="No configuro hpa"
    print-color blue
  fi
}
#
function deploy-service() {
  if [[ $DELETE_SERVICE == 'true' ]]; then
    SERVICE_EXIST=$(kubectl get service -n $NAMESPACE | grep $APPNAME)
    if [[ -n $SERVICE_EXIST ]]; then
      MENSAJE="Se va a borrar el servicio viejo y crear uno nuevo de $APPNAME"
      print-color green
      kubectl delete service $APPNAME -n $NAMESPACE
      sleep 5
    fi
    kubectl apply -f yaml/service.yaml
    kubectl -n devops-tools patch svc jenkins-server -p '{"spec": {"type": "LoadBalancer"}}'
  else
    SERVICE_EXIST=$(kubectl get service -n $NAMESPACE | grep $APPNAME)
    if [[ -z $SERVICE_EXIST ]]; then
      MENSAJE="No existe el servicio $APPNAME, se va a crear"
      print-color blue
      kubectl apply -f yaml/service.yaml
      kubectl -n $NAMESPACE patch svc $APPNAME -p '{"spec": {"type": "LoadBalancer"}}'
    fi
  fi
}
#
function update-version() {
  let VERSION=VERSION+1
  echo $VERSION > $APPNAME/version
}
#
function login-docker() {
  TOKEN=$(aws ecr get-login-password --region $AWS_REGION)

  if [[ -n $TOKEN ]]; then
    echo "$TOKEN" | docker login --username AWS --password-stdin $REGISTRY > /dev/null 2>&1
    MENSAJE="Se pudieron obtener las credenciales de docker para aws"
    print-color green
  else
    MENSAJE="No se pudieron obtener las credenciales de docker para aws"
    print-color red
    exit 1
  fi
}
#
function validate-service() {
  if [[ $DELETE_SERVICE == 'true' || $DELETE_SERVICE == 'false' ]]; then
    echo " "
  else
    MENSAJE="DELETE_SERVICE no es ni true ni false, no se puede continuar"
    print-color red
    exit 1
  fi
  #
  if [[ $HPA == 'true' || $HPA == 'false' ]]; then
    echo " "
  else
    MENSAJE="HPA no es ni true ni false, no se puede continuar"
    print-color red
    exit 1
  fi
}
#
function check-depencencies() {
  local COMMAND="docker kubectl aws"
  for i in $COMMAND; do
    if ! command -v $i &> /dev/null; then
      MENSAJE="$i -- could not be found"
      print-color red
      exit 1
    fi
  done
  #
  local FOLDER="aws kube docker"
  for i in $FOLDER; do
    if [[ ! -d ~/.$i ]]; then
      MENSAJE="No estan configurada la carpeta de $i"
      print-color red
      exit 1
    fi
  done
}

#
function main() {
  APPNAME=$FOLDER_CODE
  buscar-version
  compilar
  login-docker
  enviar
  preparo-yaml
  deploy-config-map
  deploy-kuberntes
  deploy-service
  deploy-hpa
  update-version
}
#########
prerequisites
validate-service
check-depencencies
main
