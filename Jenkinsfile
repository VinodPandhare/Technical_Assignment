pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('aws-credentials-id')  // Use the Jenkins AWS credentials ID
        AWS_REGION = 'us-west-2'  // Set your AWS region
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/VinodPandhare/Technical_Assignment.git'  // Clone the repository
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'  // Initialize Terraform to download necessary providers
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

        stage('Package Lambda Code') {
            steps {
                script {
                    // Package the Lambda code into a ZIP file
                    sh 'zip -r lambda.zip lambda_function.py'  // Ensure lambda_function.py is the correct file path
                }
            }
        }

        stage('Deploy Lambda') {
            steps {
                script {
                    // Deploy Lambda code using AWS CLI
                    if (fileExists('lambda.zip')) {
                        sh """
                            aws lambda update-function-code \\
                            --function-name vineet_lambda \\
                            --zip-file fileb://lambda.zip \\
                            --region ${AWS_REGION}
                        """
                    } else {
                        error("Lambda ZIP file not found!")
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    sh 'terraform destroy -auto-approve'  // Optionally, destroy the infrastructure after the task is completed
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
