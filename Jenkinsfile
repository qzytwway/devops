pipeline {
    agent {
        label 'maven'
    } 

    environment {
        REGISTRY_DOMAIN = "registry.cn-hangzhou.aliyuncs.com"
        REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
        REGISTRY_CREDENTIALS_ID = "b32a1d44-38da-419c-8afd-18672235b420"
        GIT_REPO = "qzytwway"
    }

    parameters {
        choice choices: ['default', 'test'], name: 'namespace'
    }

    stages {
        stage('Clone Code') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/qzytwway/devops.git'
                    GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
                    env.IMAGE_TAG = GIT_COMMIT
                }               
            }
        }
        stage('Build a Maven project') {
            steps {
                container('maven') {
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build image') {
            steps {
                withCredentials([usernamePassword(credentialsId: '2f92bff0-0c0e-413f-9454-5c5ca37d190c', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh """
                        docker login -u ${username} -p ${password} ${REGISTRY_DOMAIN}
                        docker build -t ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} .
                        docker push ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
                        docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                    configFileProvider([configFile(fileId: '02c30f8e-c78f-4bb9-bb3f-e208cb864916', targetLocation: 'admin.kubeconfig')]) {
                        script {
                            sh 'envsubst < deploy.yaml | kubectl --kubeconfig=admin.kubeconfig -n ${namespace} apply -f -'
                        }
                    }
            }
        }
    }
}