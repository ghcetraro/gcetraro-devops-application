def call()
{
    pipeline
    {
        agent any
        stages
        {
            stage('Load environment')
            {
                steps
                {
                    sh "echo Se ejecuta el pipeline_dev"
                    sh "mkdir -p $WORKSPACE/sh"
                    debug_mode()
                    writeFile([file:"$WORKSPACE/sh/$envfile",text:libraryResource("env/$envfile")])
                    load "$WORKSPACE/sh/$envfile"
                }
            }
            stage('Validaciones previas')
            {
                steps
                {
                    script
                    {
                        if(env.SkipCompile != 'true')
                        {
                            //verifico que existe el config map en el repositorio cloud_config
                            previous_validations_cloud_config()
                            pull_configs()
                        }
                    }
                }
            }
            stage('Compile Docker')
            {
                steps
                {
                    script
                    {
                        if(env.SkipCompile != 'true')
                        {
                            generate_credentials_aws()
                            generate_credentials_docker_aws()
                            proyect_js()
                            docker_build_env()
                        }
                        else
                        {
                            //se corta el proceso porque no hay imagen para deployar
                            sh 'exit 1'
                        }
                    }
                }
            }
            stage('Push Docker Image')
            {
                steps
                {
                    script
                    {
                        if(env.SkipPushImage != 'true')
                        {
                            docker_push_image()
                        }
                        else
                        {
                            //se corta el proceso porque no hay imagen para deployar
                            sh 'exit 1'
                        }
                    }
                }
            }
            stage('Deploy Docker Image')
            {
                steps
                {
                    script
                    {
                        if(env.SkipDeploy != 'true')
                        {
                            generate_credentials_kubernetes_aws()
                            kubernetes_deploy_image_env()
                        }
                    }
                }
            }
        }
        post
        {
            always
            {
                script
                {
                    sh 'echo "Finalizo el Job"'
                }
            }
            success
            {
                script
                {
                    if(env.SkipPushTag != 'true')
                    {
                        push_github_tag()
                        
                    }
                    sh 'echo "Finalizo el job de manera exitosa"'
                }
            }
            failure
            {
                script
                {
                    sh 'echo "Fallo el job"'
                }
            }
        }
        
    }
}