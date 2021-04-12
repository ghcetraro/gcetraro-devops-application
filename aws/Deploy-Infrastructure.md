# Deploy de Infraestructura

A continuación vamos a deployar a través de los cli de aws la infraestructura necesaria para hacer un mini ejemplo de deploy con ci/cd 

## Generar las credenciales para la registry de aws

    aws ecr get-login-password --region region | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

## Crear el repositorio en la registry de aws

Crear el contenedor para la imagen de la app en la Registry de AWS

    aws ecr create-repository \
    --repository-name test-app \
    --image-scanning-configuration scanOnPush=true \
    --region us-east-1

## Como pushear una imagen

Ejemplo para pushear una imagen :

Tageamos la imagen :

    docker tag hello-world:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/test-app:01

Nos logueamos a la registry :

    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

Pusheamos la imagen

    docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/test-app:01

## Deployamos un mini cluster de eks

    eksctl create cluster \
        --name k3s-lab \
        --version 1.16 \
        --nodegroup-name k3s-lab-workers \
        --node-type t2.micro \
        --nodes 3 \
        --alb-ingress-access \
        --region us-east-1

## Kubernetes

Kubernetes de AWS (EKS) tiene dos tipos de credenciales. 

    - Las credenciales que se usan desde AWS para acceder a kubernetes
    - Las credenciales internas que gestiona kubernetes

