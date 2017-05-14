node() {
    docker.withRegistry('364843010988.dkr.ecr.eu-west-1.amazonaws.com/aidan:latest', '0edf16b3-bcef-48b6-9796-f52a0c69ce39') {

        git url: "https://github.com/aidanoflann/dockerfiles", credentialsId: 'fbeb573d-43ca-4b98-9311-b4260d92ef42'

        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id

        stage "build"
        def app = docker.build "your-project-name"

        stage "publish"
        app.push 'master'
        app.push "${commit_id}"
    }
}