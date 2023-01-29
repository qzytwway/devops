pipeline {
    agent {
        label 'maven'
    } 

    stages {
        stage('Hello') {
            steps {
                git branch: 'main', url: 'https://github.com/qzytwway/devops.git'
            }
        }

        stage('build a Maven project') {
            steps {
                container('maven') {
                    sh 'mvn clean install'
                }
            }
        }
    }
}