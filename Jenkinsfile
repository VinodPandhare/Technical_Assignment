pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('aws-credentials-id')  // Use the Jenkins AWS credentials ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/VinodPandhare/Technical_Assignment.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'  // Initialize Terraform
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'  // Show the Terraform execution plan
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'  // Apply the Terraform configuration
                }
            }
        }

        stage('Deploy Lambda') {
            steps {
                script {
                    // Add deployment steps for Lambda or other components
                    sh 'aws lambda update-function-code --function-name YourLambdaFunctionName --zip-file fileb://lambda.zip'
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    sh 'terraform destroy -auto-approve'  // Optionally, add a destroy stage
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after the pipeline runs
        }
    }
}
