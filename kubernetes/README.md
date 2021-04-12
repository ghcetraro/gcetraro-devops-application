# Script de deploy para kubernetes

## Función

La función del presente script es a través de ciertas parámetros que se le pasan al inicio :
 
    - Compilar una imagen de docker en node con numero de version ascendente.
    - Generar la credenciales dinamicas de aws
    - Enviar la imagen a la registry de aws
    - Deployar en kuberntes usando la opción de recrear todo o no.
    - Deployando un configmap para el archivo de db.json

## Requisitos

Para ejecutar el script de Deploy.sh se necesita tener instalado/configurado :

    - kubectl
    - docker
    - aws cli
    - las credenciales de aws

## Parámetros

El script requiere para ejecutarse que se le pasen los siguientes parámetros :

    -a (Namespace donde se va a deployar)
    -r (cantidad de replicas del microservicio)
    -p (puerto del microservicio)
    -c (el nombre de la carpeta donde esta el código que va a ser el nombre de la app tambien, tiene que estar a la misma altura que el script)
    -d (opcion true o false -- si vamos a recrear el servicio y la ip/url del load balancer de aws)
    -f (el archivo que vamos a cargar como configmap)
    -h (opción true o false -- si vamos a setear un hpa de ejemplo)

