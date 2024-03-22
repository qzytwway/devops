def REGISTRY_DOMAIN = "192.168.10.120"
def REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
def REGISTRY_CREDENTIALS_ID = 'e672bdfa-e62d-43ae-9324-121b0cc4c731'
def GIT_REPO = "qzytwway"
pipeline {
    agent any
    options {
        ansiColor('xterm')
        timestamps()
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '5')
    }
    stages {
        stage('checkout') {
            agent {
                docker {
                    image 'maven:3.8.5'
                    reuseNode true
                }
            }
            steps {
                script {
                    checkout scm
                    GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
                    env.IMAGE_TAG = GIT_COMMIT
                    sh 'mvn clean install -Dmaven.test.skip=true'
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    docker.withRegistry(REGISTRY_URL, REGISTRY_CREDENTIALS_ID) {
                        def customImage = docker.build("${REGISTRY_DOMAIN}/${GIT_REPO}/main:${GIT_COMMIT}")
                        customImage.push()
                        customImage.push('latest')
                        sh "docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/main:${GIT_COMMIT}"
                        sh "docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/main"
                    }
                }
            }
        }    
        stage('clean ws') {
            steps {
                cleanWs()
            }
        }
    }
}
