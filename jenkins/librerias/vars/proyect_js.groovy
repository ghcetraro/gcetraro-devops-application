def call()
{
    writeFile([file:"$WORKSPACE/sh/proyect_js.sh",text:libraryResource("sh/proyect_js.sh")])
    sh "chmod +x $WORKSPACE/sh/proyect_js.sh"
    
    sh "$WORKSPACE/sh/proyect_js.sh"
}