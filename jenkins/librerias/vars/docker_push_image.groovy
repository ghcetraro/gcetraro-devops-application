def call()
{
    writeFile([file:"$WORKSPACE/sh/docker_push_image.sh",text:libraryResource("sh/docker_push_image.sh")])
    
    sh "chmod +x $WORKSPACE/sh/docker_push_image.sh"
    sh "$WORKSPACE/sh/docker_push_image.sh"
}