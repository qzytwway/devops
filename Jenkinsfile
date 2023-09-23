pipeline {
    agent {
        label 'backend'
    }
     
    options {
        ansiColor('xterm')
        timestamps()
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '5')
    }
    stages {
        stage('Clone Code') {
            steps {
                container('maven') {
                    script {                        
                        sh 'mvn clean install -Dmaven.test.skip=true'
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
