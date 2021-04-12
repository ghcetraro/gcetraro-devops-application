# Dockerizacion

Se va a dockerizar la aplicación sin hacer modificaciones en el códigp

## Construcción y despliegue de la aplicación de pruebas

Se va a generar una imagen de docker del codigo de ejemplo hecho en nodejs, a partir de una imagen ya existen de "node:14", con el Dockerfile aquí guardado.

    docker build -t <registry>/test-app:01 .

## Registry

Se va a usar la registry graturi de docker hub para enviar la imagen

    docker push <registry>/test-app:01