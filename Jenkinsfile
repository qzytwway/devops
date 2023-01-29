def REGISTRY_DOMAIN = 'reg.test.cn'
def REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
def REGISTRY_CREDENTIALS_ID = 'b32a1d44-38da-419c-8afd-18672235b420'
def GIT_REPO = 'flow'
pipeline {
    agent {
        label 'maven'
    } 

    stages {
        stage('Hello') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/qzytwway/devops.git'
                    GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
                    env.IMAGE_TAG = GIT_COMMIT
                }               
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
                withCredentials([usernamePassword(credentialsId: 'f2b16571-6852-4091-9aba-cbe06cdb021f', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh 'docker login -u "${username}" -p "${password}" "${REGISTRY_DOMAIN}"'
                    sh 'docker build -t ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} .'
                }
            }
        }
    }
}