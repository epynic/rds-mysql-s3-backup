node {
    def commit_id
    stage('Checkout SCM') {
        checkout scm
        commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    }
    stage('Docker Build and Push'){
        docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
            def customImage = docker.build("epynic/rds-mysql-s3-backup:${commit_id}", '.').push();
        }
    }
}