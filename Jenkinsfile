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

        stage('uild a Maven project') {
            sh 'mvn clean install'
        }
    }
}