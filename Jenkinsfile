pipeline {
    agent any

    environment {
        // Use Jenkins credentials for AWS access
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'  // Set your desired region here
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Checkout your code from the Git repository
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Your Docker image build commands here
                    sh 'docker build -t my-image .'
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Login to AWS ECR
                    sh 'aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin <your_ecr_url>'

                    // Tag and push the image to ECR
                    sh 'docker tag my-image:latest <your_ecr_url>/my-image:latest'
                    sh 'docker push <your_ecr_url>/my-image:latest'
                }
            }
        }

        stage('Deploy Lambda Function') {
            steps {
                script {
                    // Use AWS CLI to deploy Lambda function (example command)
                    sh 'aws lambda update-function-code --function-name my-lambda-function --zip-file fileb://lambda.zip'
                }
            }
        }
    }
}
