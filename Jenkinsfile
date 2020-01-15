node {
    def commit_id
    stage('Checkout SCM') {
        checkout scm
        commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    }
    stage('Test - To check MYSQL connect') { 
        def dockerfile = 'Dockerfile.test'
        // def mysql = docker.image('mysql:5.6').run('-e MYSQL_ALLOW_EMPTY_PASSWORD=yes')
        // // mysql.inside('-p 3306:3306'){
        // //     sh 'while ! mysqladmin ping -h0.0.0.0 --silent; do sleep 1; done'
        // // }
        // sh 'sleep 10'
        // docker.build("rds-test:latest", "-f ${dockerfile} .")
        // def rds_test_image = docker.image('rds-test:latest')
        // rds_test_image.inside("--link ${mysql.id}:mysql "){
        //     sh db_backup.sh
        // }
        // mysql.stop()
        docker.build("rds-latest", "-f ${dockerfile} .")
        def rds_test_image = docker.image('rds-test:latest')
        docker.image('mysql:5.6').withRun('-e MYSQL_ROOT_PASSWORD=admin --name=mysql_server -p 3306:3306') { container ->
            docker.image('mysql:5.6').inside("--link ${container.id}:mysql") {
                /* Wait until mysql service is up */
                sh 'while ! mysqladmin ping -hmysql --silent; do sleep 1; done'
            }

            rds_test_image.inside("--link ${container.id}:mysql -e MYSQL_HOST=mysql -e MYSQL_PWD=admin -e USER=root "){
                sh 'bash scripts/test_script.sh'
            }
        }
    }
    stage('Docker Build and Push'){
        docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
            def customImage = docker.build("epynic/rds-mysql-s3-backup:${commit_id}", '.').push()
        }
    }
}