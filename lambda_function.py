import json
import boto3
import os

def lambda_handler(event, context):
    # Environment variables
    rds_host = os.environ['RDS_HOST']
    s3_bucket = os.environ['S3_BUCKET']

    # S3 client
    s3_client = boto3.client('s3')
    rds_client = boto3.client('rds')

    # Fetch data from S3 (example)
    try:
        response = s3_client.get_object(Bucket=s3_bucket, Key='data.json')
        data = response['Body'].read().decode('utf-8')
    except Exception as e:
        print(f"Error fetching data from S3: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('Failed to fetch data from S3')
        }

    # Connect to RDS MySQL (for example, inserting data)
    try:
        # Placeholder logic for MySQL connection and data insert
        print(f"Inserting data into RDS at {rds_host}")
        # In reality, you'd use a MySQL library like pymysql to connect and execute queries
    except Exception as e:
        print(f"Error connecting to RDS: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('Failed to insert data into RDS')
        }

    return {
        'statusCode': 200,
        'body': json.dumps('Data processed successfully')
    }
