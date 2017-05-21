node() {
    git url: "https://github.com/aidanoflann/dockerfiles", credentialsId: 'dc61f703-7780-457a-a44e-9b58dac6aab7'
    sh "git rev-parse HEAD > .git/commit-id"
    def commit_id = readFile('.git/commit-id').trim()
    println commit_id

    stage "dockerfile_discover"
    sh "export DOCKER_IMAGE_NAME='base_python'"
    sh "echo \$DOCKER_IMAGE_NAME"

    stage "docker_login"
    sh "DOCKER_LOGIN_COMMAND=\$(aws ecr get-login)"
    sh "TRIMMED_COMMAND=\$(echo \$DOCKER_LOGIN_COMMAND | tr -d 'https://')"
    sh "\$TRIMMED_COMMAND"

    stage "build"
    sh "docker build . -t base_python -f base_python.Dockerfile"

    stage "publish"
    sh "docker tag base_python:latest 364843010988.dkr.ecr.eu-west-1.amazonaws.com/base_python:latest"
    sh "docker push 364843010988.dkr.ecr.eu-west-1.amazonaws.com/base_python:latest"
}
