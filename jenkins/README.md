# Configuración e Instalación de Jenkins en docker para CI/CD ejemplo

## Dockerfile

Dockerfile con los binarios necesarios para correr jenkins como container monolítico dentro de docker en local o dentro de kuberntes como pod, con volúmenes persistentes.

## Kubernetes :

Vamos a setear jenkins para correr dentro de kubernetes

### Configuración para kubernetes

Compilar el Dockerfile
    
    docker build -t 052965077586.dkr.ecr.us-east-1.amazonaws.com/jenkins-server:01 .

* En kubernets los plugins se instalan a mano en esta version ya que va a tener un volumen de kubernetes donde los guarde y no en la imagen. 

Enviar la imagen a la registry

    docker psuh 052965077586.dkr.ecr.us-east-1.amazonaws.com/jenkins-server:01

Crear el namespace donde colocar a jenkins

    kubectl apply -f yaml/namespace.yaml

Crear el volumen en kubernetes
    
    kubectl apply -f yaml/jenkins-volume.yaml

Crear el usuario de jenkins para kubernetes

    kubectl apply -f yaml/role-admin.yaml

Obtener la credencial y generar un kubeconfig

    chmod +x kubeconfig-generator.sh
    ./kubeconfig-generator.sh

Como usar las credenciales

    export KUBECONFIG=$(pwd)/test.kubeconfig

Crear el usuario para el job de la Registry

    kubectl apply -f yaml/user-cron-registry.yaml

Configurar el job que regenere la clave de la registry en kubernetes para que eks pueda pullear las imagens de la registry de AWS.

    kubectl apply -f yaml/cron-jobs-aws-registry-devops-tools.yaml
    kubectl apply -f yaml/cron-jobs-aws-registry-devops-tools.yaml

Deployar jenkins 

    kubectl apply -f yaml/jenkins-server.yaml

Exponer Jenkins 

    kubectl -n default expose deployment/jenkins-server

Exponer Jenkins por el load balancer de aws

    kubectl -n devops-tools patch svc jenkins-server -p '{"spec": {"type": "LoadBalancer"}}'

### Configuración de Métricas

Para poder utilizar hpa (horizontal pod autoscaler) es necesario instalar metricts server.

    kubectl apply -f yaml/metric-server.yaml

## Configuración Jenkins LOCAL

Vamos a setear jenkins para correr dentro en local. 
Para eso vamos a ir a la carpeta que dice local y vamos a ejecutar el el script "Deploy.sh" que nos va a crear la imagen de jenkins custom y nos lo va a desplegar.

    cd local
    chmod +x Deploy.sh
    ./Deploy.sh

## Configuración de librerías

Para poder correr jenkins con los pipelines, es necesario generar un repositorio nuevo en github y cargar la carpeta de :
    
    "librerias" 
    
luego hay que configurar en jenkins ese respositor como una librería.

## Template de ejemplo de un job

Para generar el job en jenkins, hay un template, que debe ser modificadas las variables con los nombres deseados.

    resources/template/jenkins_job_dev.xml

Generar el job desde el template con

    curl -u $TOKEN -s -X POST -H "Content-Type:application/xml" -d @jenkins_job_dev.xml "http://<JENKINS>/job/<FOLDER>/createItem?name=<REPONAME>"