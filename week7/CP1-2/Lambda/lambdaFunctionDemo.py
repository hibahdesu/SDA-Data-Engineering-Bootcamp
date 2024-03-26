import os
import boto3
import requests
import snowflake.connector as sf


def lambda_handler(event, context):

    url = 'https://de-materials-tpcds.s3.ca-central-1.amazonaws.com/inventory.csv'
    destination_folder = '/tmp'
    file_name = 'inventory.csv'
    local_file_path = '/tmp/inventory.csv'
    
    # Snowflake connection parameters
    account = 'lcryxrf-kj08803'
    warehouse = 'COMPUTE_WH'
    database = 'tpcds'
    schema = 'raw_air'
    table = 'inventory'
    user = 'wcdsnow'
    password = 'Wcd123456'
    role='accountadmin'
    stage_name = 'inv_Stage'

    # Download the data from the API endpoint
    response = requests.get(url)
    response.raise_for_status()
    
    

    # Save the data to the destination file in /tmp directory
    file_path = os.path.join(destination_folder, file_name)
    with open(file_path, 'wb') as file:
        file.write(response.content)
        
    with open(file_path, 'r') as file:
        file_content = file.read()
        print("File Content:")
        print(file_content)




    # Establish Snowflake connection
    conn = sf.connect(user = user, password = password, \
                 account = account, warehouse=warehouse, \
                  database=database,  schema=schema,  role=role)


    cursor = conn.cursor()
    
    # use schema
    use_schema = f"use schema {schema};"
    cursor.execute(use_schema)
    
    # create CSV format
    create_csv_format = f"CREATE or REPLACE FILE FORMAT COMMA_CSV TYPE ='CSV' FIELD_DELIMITER = ',';"
    cursor.execute(create_csv_format)
    

    
    

    return {
        'statusCode': 200,
        'body': 'File downloaded and uploaded to Snowflake successfully.'
    }
