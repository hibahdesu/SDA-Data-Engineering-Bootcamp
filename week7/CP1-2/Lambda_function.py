import json
import os
import boto3
import requests
import snowflake.connector as sf


def lambda_handler(event, context):
    # TODO implement

    url = 'https://de-materials-tpcds.s3.ca-central-1.amazonaws.com/inventory.csv'
    destination_folder = '/tmp'
    file_name = 'inventory.csv'
    user = 'users'
    password = 'user1234'
    account = 'DWRGTDB.NSB28040'
    warehouse = 'COMPUTE_WH'
    database = 'TPCDS'
    schema = 'RAW'
    role = 'accountadmin'
    file_formate_name = 'comma_csv'
    stage_name = 'inv_Stage'
    table = 'INVENTORY'
    response = request.get(url)

    response.raise_for_status()
    file_path = os.path.join(destination_folder, file_name)
    with open(file_path, 'wb') as file:
        file.write(response.content)

    with open(file_path, 'r') as file:
        file_content = file.read()
        print(file_content)

    # Connect to snowflake
    conn = sf.connect(user=user, password=password,
    \account = account, warehouse = warehouse,
    \database = database, schema = schema, role = role)

    cursor = conn.cursor()

    # Use warehouse
    use_warehouse = f"use warehouse {warehouse}"
    cursor.execute(use_warehouse)

    # Use schema
    use_schema = f"use schema {schema}"
    cursor.execute(use_schema)

    # Create file formate
    create_csv_foramte = f"create or replace file formate {file_formate_name} type = 'csv' field_delamater=',' ;"
    cursor.execute(create_csv_foramte)

    # Create stage query
    create_stage_query = f"CREATE OR REPLACE STAGE {stage_name} FILE_FORMAT =COMMA_CSV"
    cursor.execute(create_stage_query)

    # Copy the file from local to the stage
    copy_into_stage_query = f"PUT 'file://{local_file_path}' @{stage_name}"
    cursor.execute(copy_into_stage_query)

    # List the stage
    list_stage_query = f"LIST @{stage_name}"
    cursor.execute(list_stage_query)

    # truncate table
    truncate_table = f"truncate table {schema}.{table};"
    cursor.execute(truncate_table)

    # Load the data from the stage into a table (example)
    copy_into_query = f"COPY INTO {schema}.{table} FROM @{stage_name}/{file_name} FILE_FORMAT =COMMA_CSV;"
    cursor.execute(copy_into_query)

    print("File uploaded to Snowflake successfully.")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
