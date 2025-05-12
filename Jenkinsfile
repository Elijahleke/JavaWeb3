pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDS = credentials('dockerhub')
        IMAGE_NAME = 'elijahleke/java-calculator'
        IMAGE_TAG = "build-${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                sh '''
                    docker stop java-calculator || true
                    docker rm java-calculator || true
                    docker run -d -p 9090:8080 --name java-calculator ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
