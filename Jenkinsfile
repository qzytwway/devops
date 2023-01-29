podTemplate(
    namespace: "devops",
    containers: [
    containerTemplate(name: 'maven', image: 'maven:3.8.5-openjdk-17', command: '/bin/bash', ttyEnabled: true)
    // containerTemplate(name: 'golang', image: 'golang:1.16.5', command: 'sleep', args: '99d')
  ]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            git branch: 'main', url: 'https://github.com/qzytwway/devops.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn clean install'
                }
                // stage('Integration testing') {
                //     sh 'mvn verify -DskipUnitTests'
                // }
            }
        }
    }
}