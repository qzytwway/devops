def REGISTRY_DOMAIN = "registry.cn-hangzhou.aliyuncs.com"
def REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
def REGISTRY_CREDENTIALS_ID = 'b32a1d44-38da-419c-8afd-18672235b420'
def GIT_REPO = 'qzytwway'
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

        stage('test') {
            steps {
                container(kubectl) {
                    kubeconfig(credentialsId: '8230b7e9-d3b3-4c2b-bcf4-e95b3326d764', serverUrl: 'https://kubernetes.default.svc.cluster.local') {
                        sh 'kubectl get pod'
                }
                }
            }
        }

        // stage('build a Maven project') {
        //     steps {
        //         container('maven') {
        //             sh 'mvn clean install'
        //         }
        //     }
        // }

        // stage('build image') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: '2f92bff0-0c0e-413f-9454-5c5ca37d190c', passwordVariable: 'password', usernameVariable: 'username')]) {
        //             sh """
        //                 docker login -u ${username} -p ${password} ${REGISTRY_DOMAIN}
        //                 docker build -t ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} .
        //                 docker push ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
        //                 docker rmi ${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT}
        //             """
        //         }
        //     }
        // }
    }
}