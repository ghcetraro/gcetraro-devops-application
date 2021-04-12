def call()
{
    writeFile([file:"$WORKSPACE/sh/generate_credentials_aws.sh",text:libraryResource("sh/generate_credentials_aws.sh")])
    
    sh "chmod +x $WORKSPACE/sh/generate_credentials_aws.sh"
    
    withCredentials([usernamePassword(credentialsId: 'aws', usernameVariable: 'username', passwordVariable: 'password' )])
    {
        sh "$WORKSPACE/sh/generate_credentials_aws.sh ${env.username} ${env.password}"
    }
}