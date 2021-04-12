def call()
{
	writeFile([file:"$WORKSPACE/sh/kubernetes_deploy_image_env.sh",text:libraryResource("sh/kubernetes_deploy_image_env.sh")])
	writeFile([file:"$WORKSPACE/sh/pod.yaml",text:libraryResource("template/kubernetes.pod.deployment.env")])
	writeFile([file:"$WORKSPACE/sh/service.yaml",text:libraryResource("template/kubernetes.service.internal.env")])

	sh "chmod +x $WORKSPACE/sh/kubernetes_deploy_image_env.sh"
	
	sh "$WORKSPACE/sh/kubernetes_deploy_image_env.sh"
}