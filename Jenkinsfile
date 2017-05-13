node() {
    docker.withRegistry('364843010988.dkr.ecr.eu-west-1.amazonaws.com/aidan:latest', '20ed6f47-04ae-4534-953c-8a230afac6d6') {

        git url: "https://github.com/aidanoflann/dockerfiles", credentialsId: '03dcf7ec-7a9d-4008-ba17-fcbbf7d83f3f'

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