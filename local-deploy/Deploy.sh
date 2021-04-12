#!/bin/bash

IMAGEN="telecom"
EVN="dev"
FOLDER="/data/docker/$EVN/$IMAGEN/json"
VERSION=$(cat version)
PUERTO="3000"
FILE="code/db.json"
URL="http://localhost:3000/api/users"
#
function replace-deploy() {
  cp template.docker-compose.yml docker-compose.yml
  sed -i s,%IMAGE%,$IMAGEN:$VERSION,g docker-compose.yml
  docker-compose up -d
}
#
if [[ ! -e $FOLDER ]]; then
  echo "Creo la carpeta $FOLDER para dejar el json"
  sudo mkdir -p $FOLDER
fi
#
echo "Copio el archivo $FILE"
sudo cp $FILE $FOLDER/
echo "Doy permisos sobre $FOLDER"
sudo chmod -R 775 $FOLDER
#
echo "Compilo la imagen"
docker build -t "$IMAGEN:$VERSION" . > /dev/null 2>&1
#
echo "Deployo la imagen"
if [[ -n $(docker ps -a | grep $IMAGEN | grep [0-9][0-9] | grep :$PUERTO) ]]; then
  DEL=$(docker ps -a | grep telecom | grep [0-9][0-9] | grep :$PUERTO | awk -F " " '{print $1}')
  echo "Borro el container viejo"
  docker rm -fv $DEL
  sleep 5
  echo "Deployo el container nuevo"
  replace-deploy
  sleep 5
else
  echo "Deployo el container nuevo"
  replace-deploy
  sleep 5
fi
#
if [[ -n $(docker ps -a | grep $IMAGEN | grep :$VERSION | grep :$PUERTO) ]]; then
  echo "Abro el browser para testear la app"
  if [[ -n $(command -v firefox $URL) ]]; then
    firefox $URL
  elif [[ -n $(command -v google-chrome-stable $URL) ]]; then
    google-chrome-stable $URL
  elif [[ -n $(command -v opera) ]]; then
    opera $URL
  elif [[ -n $(command -v brave-browser-stable $URL) ]]; then
    brave-browser-stable $URL
  fi

else
  echo "No se pudo desplegar la app"
fi
#
echo "Autmento la version"
let VERSION=VERSION+1
echo $VERSION > version
#fin
