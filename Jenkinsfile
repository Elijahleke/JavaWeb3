pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDS = credentials('dockerhub')
        IMAGE_NAME = 'elijahleke/java-calculator'
        IMAGE_TAG = 'latest'
    }
    
    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                sh 'echo ${DOCKER_HUB_CREDS_PSW} | docker login -u ${DOCKER_HUB_CREDS_USR} --password-stdin'
                sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'docker stop java-calculator || true'
                sh 'docker rm java-calculator || true'
                sh 'docker run -d -p 9090:8080 --name java-calculator ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
    }
}
