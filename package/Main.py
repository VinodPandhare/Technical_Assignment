import boto3
import pandas as pd
import os
import mysql.connector
from mysql.connector import Error
from io import StringIO

# Initialize AWS clients
s3_client = boto3.client('s3')
rds_client = boto3.client('rds')
glue_client = boto3.client('glue', region_name='us-east-1')  # Replace with your region

def read_data_from_s3(bucket_name, file_key):
    try:
        # Download the file from S3
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        file_content = response['Body'].read().decode('utf-8')
        
        # Use StringIO to convert string into a file-like object
        data = pd.read_csv(StringIO(file_content))
        return data
    except Exception as e:
        print(f"Error reading from S3: {e}")
        return None

def push_to_rds(data, rds_host, db_name, username, password):
    try:
        # Establish RDS connection
        conn = mysql.connector.connect(
            host=rds_host,
            database=db_name,
            user=username,
            password=password
        )
        
        cursor = conn.cursor()
        for index, row in data.iterrows():
            cursor.execute("INSERT INTO my_table (col1, col2) VALUES (%s, %s)", (row['col1'], row['col2']))
        
        conn.commit()
        print("Data pushed to RDS successfully!")
    except Error as e:
        print(f"Error pushing to RDS: {e}")
        return False
    finally:
        if conn:
            conn.close()
    return True

def push_to_glue(data):
    try:
        # Create the Glue table (ensure that your Glue database exists)
        glue_client.create_table(
            DatabaseName='my_database',
            TableInput={
                'Name': 'my_table',
                'StorageDescriptor': {
                    'Columns': [{'Name': 'col1', 'Type': 'string'}, {'Name': 'col2', 'Type': 'string'}],
                    'Location': 's3://my-glue-data/',  # Specify the S3 location for Glue
                }
            }
        )
        print("Data pushed to Glue successfully!")
    except Exception as e:
        print(f"Error pushing to Glue: {e}")

def main():
    bucket_name = os.environ.get('S3_BUCKET_NAME')
    file_key = os.environ.get('S3_FILE_KEY')
    rds_host = os.environ.get('RDS_HOST')
    db_name = os.environ.get('DB_NAME')
    db_user = os.environ.get('DB_USER')
    db_password = os.environ.get('DB_PASSWORD')
    
    data = read_data_from_s3(bucket_name, file_key)
    if data is not None:
        if not push_to_rds(data, rds_host, db_name, db_user, db_password):
            push_to_glue(data)

if __name__ == "__main__":
    main()
