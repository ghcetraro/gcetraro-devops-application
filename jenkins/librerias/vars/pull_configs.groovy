
def call() {

    writeFile([
        file:"$WORKSPACE/Dockerfile",
        text:libraryResource("dockerfile/${env.dockerfile}")
    ])

    writeFile([
            file:"$WORKSPACE/node-filebite.yml",
            text:libraryResource("template/node-filebite.yml")
    ])

    writeFile([
        file:"$WORKSPACE/docker-entrypoint-node.sh",
        text:libraryResource("template/docker-entrypoint-node.sh")
    ])

    // Be0x83: soporte para sitios estaticos
    writeFile([
        file:"$WORKSPACE/docker-entrypoint-nginx.sh",
        text:libraryResource("template/docker-entrypoint-nginx.sh")
    ])

    // Be0x83:
    // Se agregan al proceso de compilación dos archivos:

    // - dockerignore > descarta archivos en proceso de compilación
    writeFile([
        file:"$WORKSPACE/.dockerignore",
        text:libraryResource("dockerfile/dockerignore")
    ])

    // - ormconfig.js > configuración para la conexión contra la base de datos
    writeFile([
        file:"$WORKSPACE/ormconfig.build.js",
        text:libraryResource("config/ormconfig.js")
    ])

}
