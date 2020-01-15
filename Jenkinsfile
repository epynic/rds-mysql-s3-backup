node {
    def commit_id
    stage('Checkout SCM') {
        checkout scm
        commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    }
    stage('Test - To check MYSQL connect') { //The actual container is for RDS
        def dockerfile = 'Dockerfile.test'
        def mysql = docker.image('mysql:5.6').withRun('-e MYSQL_ALLOW_EMPTY_PASSWORD=yes')
        def rds_test_image = docker.build("rds-test", "-f ${dockerfile} .")
        rds_test_image.inside("--link ${mysql.id}:mysql ")
    }
    stage('Docker Build and Push'){
        docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
            def customImage = docker.build("epynic/rds-mysql-s3-backup:${commit_id}", '.').push()
        }
    }
}