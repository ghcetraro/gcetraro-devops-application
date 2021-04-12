#!/bin/bash
#
IMAGEN="jenkins"
VERSION="01"
PUERTO="8080"
URL="http://localhost:$PUERTO"
#
echo "Verifico que los puertos no estan usuados"
if [[ -z $(sudo netstat -tupane | grep 8080) ]]; then
  if [[ -z $(sudo netstat -tupane | grep 2222) ]]; then
    if [[ -z $(sudo netstat -tupane | grep 50000) ]]; then
      echo "Pasa la verificacion de puertos libres 8080, 2222, 50000"
    else
      echo "Esta usado el puerto 50000, apagarlo para continuad"
      exit 1
    fi
  else
    echo "Esta usado el puerto 2222, apagarlo para continuad"
    exit 1
  fi
else
  echo "Esta usado el puerto 8080, apagarlo para continuad"
  exit 1
fi
#
echo "Compilo la imagen de docker jenkins"
docker build -t "$IMAGEN:$VERSION" .
#
echo "Despliego"
docker-compose -f docker-compose.yaml up -d
#
if [[ -n $(docker ps -a | grep $IMAGEN | grep :$VERSION | grep :$PUERTO) ]]; then
  echo "Abro el browser para testear la app"
  if [[ -n $(command -v firefox $PUERTO) ]]; then
    firefox $URL
  elif [[ -n $(command -v google-chrome-stable $PUERTO) ]]; then
    google-chrome-stable $URL
  elif [[ -n $(command -v opera) ]]; then
    opera $URL
  elif [[ -n $(command -v brave-browser-stable $PUERTO) ]]; then
    brave-browser-stable $URL
  fi

else
  echo "No se pudo desplegar la app"
fi
