pipeline {
    agent {
        label 'maven'
    } 

    stages {
        stage('Hello') {
            steps {
                git branch: 'main', url: 'https://github.com/qzytwway/devops.git'
                GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
                env.IMAGE_TAG = GIT_COMMIT
            }
        }

        stage('build a Maven project') {
            steps {
                container('maven') {
                    sh 'mvn clean install'
                }
            }
        }

        stage('build image') {
            steps {
                sh """
                env
                """
            }
        }
    }
}