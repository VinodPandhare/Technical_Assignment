provider "aws" {
  region = "us-east-1" # Replace with your AWS region
}

# Fetch the Default VPC
resource "aws_default_vpc" "default" {}

# Fetch Subnets in the Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# S3 Bucket
resource "aws_s3_bucket" "vineet_s3" {
  bucket        = "vineet-bucket-${random_integer.random_id.result}"
  force_destroy = true
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "vineet-security-group"
  description = "Security group for Vineet resources"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "vineet_rds" {
  identifier            = "vineet-rds"
  engine                = "mysql"
  engine_version        = "8.0.40"  # Use the available version
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  storage_type          = "gp2"
  db_name               = "mydatabase"
  username              = "admin"
  password              = "StrongPassword123"
  publicly_accessible   = true
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  db_subnet_group_name  = aws_db_subnet_group.default.name
}


# RDS Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "vineet-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "Vineet DB Subnet Group"
  }
}

# ECR Repository
resource "aws_ecr_repository" "vineet_ecr" {
  name = "vineet-ecr"
}

# Lambda Role
resource "aws_iam_role" "vineet_lambda_role" {
  name = "vineet-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policies to Lambda Role
resource "aws_iam_role_policy_attachment" "vineet_lambda_role_attachment" {
  role       = aws_iam_role.vineet_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "vineet_lambda" {
  function_name = "vineet-lambda"
  role          = aws_iam_role.vineet_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"  # Updated to nodejs18.x

  # Ensure this file exists in your working directory
  filename         = "lambda.zip"  # Ensure the file is present
  source_code_hash = filebase64sha256("lambda.zip")
}

# Generate Random ID for Uniqueness
resource "random_integer" "random_id" {
  min = 10000
  max = 99999
}
