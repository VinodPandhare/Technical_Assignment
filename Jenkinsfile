pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'  // Specify your AWS region
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your Git repository
                checkout scm
            }
        }
        
        stage('Install Terraform') {
            steps {
                script {
                    // Ensure Terraform is installed and available on Jenkins
                    sh 'terraform --version'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform (make sure your .tf files are in place)
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Generate and display the Terraform execution plan
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform plan to create resources
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Lambda Function') {
            steps {
                // Use withCredentials to securely access your AWS credentials
                withCredentials([aws(credentialsId: 'aws-credentials-id', region: AWS_REGION)]) {
                    script {
                        // Assuming your Lambda function code is in 'lambda_function.py'
                        sh 'aws lambda update-function-code --function-name myLambdaFunction --zip-file fileb://lambda_function.zip'
                    }
                }
            }
        }
    }
    post {
        always {
            // Cleanup or notifications after pipeline execution
            echo 'Pipeline execution completed.'
        }
    }
}
