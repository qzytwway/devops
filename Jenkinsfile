pipeline {
    agent {
        label 'maven'
    } 

    environment {
        REGISTRY_DOMAIN = "192.168.50.120"
        REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
        REGISTRY_CREDENTIALS_ID = "5e048a8c-6cd1-4524-8c3d-d47c26dfaa60"
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
                    script {
                        try {
                            if (env.TAG_NAME == null) {
                                def response = httpRequest url: "${REGISTRY_URL}/api/repositories/${GIT_REPO}/${env.BRANCH_NAME}/tags/${GIT_COMMIT}",authentication: "${REGISTRY_CREDENTIALS_ID}"
                            } else {
                                def response = httpRequest url: "${REGISTRY_URL}/api/repositories/${GIT_REPO}/release/tags/${env.TAG_NAME}",authentication: "${REGISTRY_CREDENTIALS_ID}"
                            }
                            env.IMAGE_EXSIT = "1"
                            currentBuild.result = 'SUCCESS'
                            echo "Docker image is already exsit, So skip build stage"
                            return
                        }   catch(err) {
                                sh 'gradle clean build -x test --refresh-dependencies'
                        }
                    }
                }
            }
        }

        stage('Build image') {
            steps {
                withCredentials([usernamePassword(credentialsId: '5e048a8c-6cd1-4524-8c3d-d47c26dfaa60', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh """
                        docker login -u ${username} -p ${password} ${REGISTRY_DOMAIN}
                        docker build -t ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} .
                        docker push ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
                        docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
                    """
                }
            }
        }

        // stage('Deploy') {
        //     steps {
        //             configFileProvider([configFile(fileId: '02c30f8e-c78f-4bb9-bb3f-e208cb864916', targetLocation: 'admin.kubeconfig')]) {
        //                 script {
        //                     sh "envsubst < deploy.yaml | kubectl --kubeconfig=admin.kubeconfig -n ${params.namespace} apply -f -"
        //                 }
        //             }
        //     }
        // }
    }
}