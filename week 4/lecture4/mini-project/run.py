#!/usr/bin python3
"""
This is the main file for the lambda project. It will be used in EC2 IAM role situation
"""
import sqlalchemy as db
import pandas as pd
import subprocess
import toml
import os
from dotenv import load_dotenv

# def mysql_connect(host, user, password, database, port,schema):
#     """
#     Connect to the database
#     """
#     engine = db.create_engine(f'mysql+mysqlconnector://{user}:{password}@{database}.{host}:{port}/{schema}')
#     return engine
# 
# if __name__=="__main__": 
#     app_config = toml.load('config_file.toml')
# 
#     host=app_config['db']['host']
#     port=app_config['db']['port']
#     database=app_config['db']['database']
#     schema=app_config['db']['schema']
# 
#     bucket=app_config['s3']['bucket']
#     folder=app_config['s3']['folder']
# 
# 
# 
#     # load_dotenv()
#     user = 'admin'
#     password = '12345678'
#     # user=os.getenv('user')
#     # password=os.getenv('password')
# 
# 
#     sql="""
#     SELECT CustomerID, ProductID, SUM(Sales) AS most_pur
#     FROM orders
#     GROUP BY CustomerID
#     ORDER BY most_pur DESC
#     LIMIT 10;
#     """
#     engine = mysql_connect(host, 'admin', '12345678', database, port,schema)
# 
#     df = pd.read_sql(sql, con = engine)
#     df[["customerID"]].head()
#     df[["customerID"]].to_json('cus_id.json')

subprocess.call(['aws','s3','cp','cus_id.json', f's3://{bucket}/{folder}/cus_id.json'])
