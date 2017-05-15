node() {
    docker.withRegistry('http://364843010988.dkr.ecr.eu-west-1.amazonaws.com/aidan', '76f4ee9e-e579-407d-b3c0-b03b537581db') {

        git url: "https://github.com/aidanoflann/dockerfiles", credentialsId: 'dc61f703-7780-457a-a44e-9b58dac6aab7'
        hostname
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id

        stage "build"
        def app = docker.build "base_python -f base_python/Dockerfile"

        stage "publish"
        app.push 'master'
        app.push "${commit_id}"
    }
}