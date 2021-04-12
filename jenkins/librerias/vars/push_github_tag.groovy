def call()
{
    sh "echo Carga los datos para el push tag"
    
    if ( env.debug_mode == 'true')
    {
        sh "cat $WORKSPACE/sh/docker_load"
    }
    
    load "$WORKSPACE/sh/docker_load"
    
    withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'username', passwordVariable: 'password' )])
    {
        env.encodedPass=URLEncoder.encode(password, "UTF-8")
        
        sh "echo Genero las credenciales"
        sh "sed -i s/github/${username}:${encodedPass}@github/g $WORKSPACE/.git/config"
        
        if ( env.debug_mode == 'true')
        {
            sh "cat $WORKSPACE/.git/config"
        }
        
        sh "echo Genero el tag"
        sh "git tag ${env.GITHUB_TAG}"
        
        sh "echo Hago el push tag"
        sh("git push origin ${env.GITHUB_TAG}")
    }
}




