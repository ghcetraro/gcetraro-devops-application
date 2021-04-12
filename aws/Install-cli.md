# Instalar herramientas necesarias para la tarea

## Instalar cli de aws en linux

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

## Instalar cli para configurar el cluster de k3s

    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    eksctl version

## Cargar credenciales

Una vez instalados los clientes es necesario cargar las credenciales para poder conectarse. Para eso es necesario ir a la web de aws, logearse, ir a :

     - Mis credenciales de seguridad"
     - Usuarios
     - Crear un usuario
     - Crear grupo devops con permisos y agregar el usuario
     - Permisos :
            Registry : AmazonEC2ContainerRegistryFullAccess
            EC2 : AmazonEC2FullAccess
            Cloud : AWSCloudFormationFullAccess
            EKS : AmazonEKSClusterPolicy

            Configuraciones especiales para este caso, se adjuntan json:
                EksAllAccess
                IamLimitedAccess

     - Darle permisos
     - Copiar el ID y Clave para poder conectarse por consola

Ahora abrimos una consola y configuramos el cli
    
    Ejecutamos :
        aws configure

    Y nos pedira :

        AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
        AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
        Default region name [None]: us-east-1
        Default output format [None]: json

        * En region, poner la zona que prefiramos nosotros

## Instalar cli para kubernetes

    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

## Instalar Docker sobre desktop Ubuntu

Instalar Docker en tu maquina para poder usar las herramientas

    sudo apt-get remove docker docker-engine docker.io containerd runc

    sudo apt-get update
    
    sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io

## Instalar docker-compose para despliegue local

### Instalación de docker-compose para linux

Pasos a seguir ; 

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose

    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    docker-compose --version

