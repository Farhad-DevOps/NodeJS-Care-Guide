pipeline {
    agent any
    
    environment {
        // Docker Hub Configuration
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        DOCKERHUB_NAMESPACE = 'alam1616'
        
        // Image Names
        IMAGE = "${DOCKERHUB_NAMESPACE}/Care-guide-app"
                
        // Build Number as Tag
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        LATEST_TAG = "latest"
        
        // Git Commit Hash
        GIT_COMMIT_SHORT = "${env.GIT_COMMIT.take(7)}"
    }

    stages {
        // ==================== BUILD STAGE ====================
        stage('Pull Code') {
            steps {
                git branch: 'master', credentialsId: 'GitHub_pass', url: 'https://github.com/Farhad-DevOps/Hydrus-Digital-App-CI-CD.git'
            }
        }
       
        stage('Display Files') {
            steps {
                sh 'ls -la'
            }
        }
		
		stage('Checkout Code') {
            steps {
                checkout scm
                echo "✅ Code checked out from GitHub"
                echo "Git Commit: ${env.GIT_COMMIT}"
                echo "Branch: ${env.BRANCH_NAME}"
                echo "Build Number: ${env.BUILD_NUMBER}"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dir('app') {
                        sh """
                            docker build -t ${IMAGE}:${IMAGE_TAG} .
                            docker tag ${IMAGE}:${IMAGE_TAG} ${IMAGE}:${GIT_COMMIT_SHORT}
                            docker tag ${IMAGE}:${IMAGE_TAG} ${IMAGE}:${LATEST_TAG}
                            echo "✅ app image built: ${IMAGE}:${IMAGE_TAG}"
                        """
                    }
                }
            }
        }
        
         
       
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: env.DOCKERHUB_CREDENTIALS,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            echo "🔐 Logging into Docker Hub..."
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            
                            echo "📤 Pushing backend images..."
                            docker push ${IMAGE}:${IMAGE_TAG}
                            docker push ${IMAGE}:${GIT_COMMIT_SHORT}
                            docker push ${IMAGE}:${LATEST_TAG}
                                                                                  
                            echo "✅ All images pushed successfully to Docker Hub"
                        """
                    }
                }
            }
        }
                       
    }
}
