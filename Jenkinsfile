podTemplate(
    volumes: [configMapVolume(configMapName: 'docker-config', mountPath: '/kaniko/.docker/')],
    containers: [
    containerTemplate(name: 'maven', image: 'registry.aliyuncs.com/qzytwway/maven:3.8.5', command: '/bin/sh', ttyEnabled: true),
    containerTemplate(name: 'kaniko', image: 'registry.aliyuncs.com/qzytwway/executor:debug', command: '/bin/sh', ttyEnabled: true)
  ]) {
    def REGISTRY_DOMAIN = "192.168.10.120:85"
    def REGISTRY_URL = "http://${REGISTRY_DOMAIN}"
    def GIT_REPO = "qzytwway"
    def REGISTRY_CREDENTIALS_ID = "196d2faf-91a5-4ecb-943c-a3bfe2aa5ede"
    
    properties(
        [
            disableConcurrentBuilds(),
            buildDiscarder(
                logRotator(
                    artifactDaysToKeepStr: '',
                    artifactNumToKeepStr: '',
                    daysToKeepStr: '30',
                    numToKeepStr: '5'
                )
            )
        ]
    )
    
    node(POD_LABEL) {

        timestamps {
            try {
                container('maven') {
                    stage('Clone Code') {
                        git branch: 'main', url: 'https://github.com/qzytwway/devops.git'
                        GIT_COMMIT = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
                        env.IMAGE_TAG = GIT_COMMIT
                            }               
                    stage('Build a Maven project') {
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
                container('kaniko') {
                    stage('build image') {
                        if (env.IMAGE_EXSIT == "1") {
                        currentBuild.result = 'SUCCESS'
                        return
                    }   else {
                            if (env.TAG_NAME == null) {
                                sh "/kaniko/executor --context `pwd` --dockerfile `pwd`/Dockerfile --destination=${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:${GIT_COMMIT} --destination=${REGISTRY_DOMAIN}/${GIT_REPO}/${env.BRANCH_NAME}:latest"
                        }   else {
                                sh "/kaniko/executor --context `pwd` --dockerfile `pwd`/Dockerfile --destination=${REGISTRY_DOMAIN}/${GIT_REPO}/release:${env.TAG_NAME}"
                        }
                    }
                    }
                } 
            } catch(err) {
                    currentBuild.result = 'FAILURE'
            } finally {
                    stage('Clean WS'){
                    cleanWs()
              }
            }
        }
    }
}
