def call()
{
    writeFile([file:"$WORKSPACE/sh/generate_credentials_docker_aws.sh",text:libraryResource("sh/generate_credentials_docker_aws.sh")])
    
    sh "chmod +x $WORKSPACE/sh/generate_credentials_docker_aws.sh"
    
    sh "$WORKSPACE/sh/generate_credentials_docker_aws.sh"
}