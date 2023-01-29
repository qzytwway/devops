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

        stage('build a Maven project') {
            steps {
                container('maven') {
                    sh 'mvn clean install'
                }
            }
        }

        stage('build image') {
            steps {
                publishHTML(
	                    [
		                    allowMissing: false, 
		                    alwaysLinkToLastBuild: false, 
		                    keepAll: false, 
		                    reportDir: '.', 
		                    reportFiles: 'index.html', 
		                    reportName: '自动化测试报告', 
		                    reportTitles: '自动化测试', 
		                    useWrapperFileDirectly: false
		                ]
                    )
            }
        }
    }
}