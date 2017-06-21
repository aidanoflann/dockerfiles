node() {
    git url: "https://github.com/aidanoflann/dockerfiles", credentialsId: 'dc61f703-7780-457a-a44e-9b58dac6aab7'
    sh "git rev-parse HEAD > .git/commit-id"
    def commit_id = readFile('.git/commit-id').trim()
    println commit_id

    stage("dockerfile_discover")
    {
        def DOCKER_IMAGE_NAME="mysql"
    }

    stage("docker_loginn")
    {
        sh "DOCKER_LOGIN_COMMAND=\$(aws ecr get-login)"
        sh "TRIMMED_COMMAND=\$(echo \$DOCKER_LOGIN_COMMAND | tr -d 'https://')"
        sh "\$TRIMMED_COMMAND"
    }

    stage("build")
    {
        sh "DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME};" + 'docker build . -t $DOCKER_IMAGE_NAME -f $DOCKER_IMAGE_NAME.Dockerfile'
    }

    stage("publish")
    {
        sh "DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME};" + 'docker tag $DOCKER_IMAGE_NAME:latest 364843010988.dkr.ecr.eu-west-1.amazonaws.com/$DOCKER_IMAGE_NAME:latest'
        sh "DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME};" + 'docker push 364843010988.dkr.ecr.eu-west-1.amazonaws.com/$DOCKER_IMAGE_NAME:latest'
    }
}
