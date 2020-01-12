job('test-ops-s3-rds-backup'){
    scm{
        git('git://github.com/epynic/rds-mysql-s3-backup.git') { node -> // is hudson.plugins.git.GitSCM
            node / gitConfigName('DSL User')
            node / gitConfigEmail('me@me.com')
        }
    }
    triggers{
        scm('H/5 * * * *')
    }
    steps{
        dockerBuildAndPublish {
            repositoryName('epynic/rds-mysql-s3-backup')
            tag('${GIT_REVISION,length=7}')
            registryCredentials('DockerHub')
            createFingerprints(false)
            skipDecorate()
        }
    }
}