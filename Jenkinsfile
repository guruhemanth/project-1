pipeline {
    agent any

    environment {
        IMAGE_NAME = 'local-flask-helloworld'
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "Code checkout successful."
            }
        }

        stage('Build Docker Image Locally') {
            steps {
                script {
                    echo "Building image ${IMAGE_NAME}:${IMAGE_TAG} on local Docker daemon..."
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Deploy to Local Kubernetes (Docker Desktop)') {
            steps {
                script {
                    echo "Deploying to Docker Desktop Kubernetes..."
                    sh '''
                        # Copy the kubeconfig to a temporary location so we don't accidentally modify the host machine's config!
                        cp ~/.kube/config /tmp/jenkins-kubeconfig
                        export KUBECONFIG=/tmp/jenkins-kubeconfig
                        
                        # Fix the kubeconfig IP because Jenkins is inside a container and can't use 127.0.0.1
                        sed -i 's/127.0.0.1:50060/host.docker.internal:50060/g' /tmp/jenkins-kubeconfig
                        
                        # Skip TLS verification because the cert is only valid for localhost
                        kubectl config set-cluster docker-desktop --insecure-skip-tls-verify=true
                        
                        # Switch kubectl context to docker-desktop just to be safe
                        kubectl config use-context docker-desktop
                        
                        # Apply the local deployment
                        kubectl apply -f local-deployment.yaml
                        
                        # Force rollout restart to use the newly built image
                        kubectl rollout restart deployment newhello-deployment
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Local CI/CD Pipeline Completed Successfully! Application is live on Docker Desktop."
        }
        failure {
            echo "Local Pipeline Failed. Please check the logs."
        }
    }
}
