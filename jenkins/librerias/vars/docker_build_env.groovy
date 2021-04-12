def call() 
{
	writeFile([ file:"$WORKSPACE/sh/docker_build_env.sh", text:libraryResource("sh/docker_build_env.sh") ])

	sh "chmod +x $WORKSPACE/sh/docker_build_env.sh"
	sh "$WORKSPACE/sh/docker_build_env.sh ${BUILD_NUMBER}"
}
