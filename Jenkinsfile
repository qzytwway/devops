pipeline {
    agent {
        label 'maven'
    } 

    environment {
        REGISTRY_DOMAIN = "192.168.50.120"
        REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
        REGISTRY_CREDENTIALS_ID = "9d5f961c-3982-4bbf-a28a-fa0ff602eafa"
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
                                def response = httpRequest url: "${REGISTRY_URL}/api/v2.0/projects/${GIT_REPO}/repositories/${env.BRANCH_NAME}/artifacts/${GIT_COMMIT}",authentication: "${REGISTRY_CREDENTIALS_ID}"
                            } else {
                                def response = httpRequest url: "${REGISTRY_URL}/api/v2.0/projects/${GIT_REPO}/repositories/release/artifacts/${env.TAG_NAME}",authentication: "${REGISTRY_CREDENTIALS_ID}"
                            }
                            env.IMAGE_EXSIT = "1"
                            currentBuild.result = 'SUCCESS'
                            echo "Docker image is already exsit, So skip build stage"
                            return
                        }   catch(err) {
                                sh 'mvn clean install'
                        }
                    }
                }
            }
        }

        stage('Build image') {
            steps {
                script {
                    if (env.IMAGE_EXSIT == "1") {
                    currentBuild.result = 'SUCCESS'
                    return
                }   else {
                        withCredentials([usernamePassword(credentialsId: '9d5f961c-3982-4bbf-a28a-fa0ff602eafa', passwordVariable: 'password', usernameVariable: 'username')]) {
                            if (env.TAG_NAME == null) {
                                sh """
                                    echo 'we will build branch image'
                                    docker login -u ${username} -p ${password} ${REGISTRY_DOMAIN}
                                    docker build -t ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} .
                                    docker push ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
                                    docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
                                """  
                           } else {
                              sh """
                                    docker login -u ${username} -p ${password} ${REGISTRY_DOMAIN}
                                    docker build -t ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} .
                                    docker push ${REGISTRY_DOMAIN}/${GIT_REPO}/release:${env.TAG_NAME}
                                    docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/release:${env.TAG_NAME}
                              """
                           }
                        }
                    }
                }   
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