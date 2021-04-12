def call()
{
    
    writeFile([file:"$WORKSPACE/sh/config_null.sh",text:libraryResource("sh/config_null.sh")])
    
    sh "chmod +x $WORKSPACE/sh/config_null.sh > /dev/null 2>&1"
    sh "echo Verifico que no exista la carpeta cloud_config local"
    sh '''[ -d $WORKSPACE/cloud_config ] && rm -fr  $WORKSPACE/sh/cloud_config || echo "no existe"'''
    sh "mv $WORKSPACE/.git $WORKSPACE/git"
    
    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'password', usernameVariable: 'username')]) 
    {
        env.encodedPass=URLEncoder.encode(password, "UTF-8")
        sh "echo Me clono el repositor cloud_config.git de github"
        sh "git clone https://${username}:${encodedPass}@github.com/$organization/cloud_config.git $WORKSPACE/sh/cloud_config"
    }
    
    sh "$WORKSPACE/sh/config_null.sh ${env.namespace} $WORKSPACE"
    sh "mv $WORKSPACE/git $WORKSPACE/.git"
    sh "rm -fr $WORKSPACE/sh/cloud_config"
}
