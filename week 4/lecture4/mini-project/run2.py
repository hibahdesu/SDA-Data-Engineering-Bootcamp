#!/usr/bin/env python
# coding: utf-8

# In[1]:


# pip install pymysql


# In[2]:


# pip install subprocess


# In[3]:


#Importing the libraries
import requests
import pandas as pd
import json 
import sqlalchemy as db
from dotenv import load_dotenv
from datetime import date
import os
import toml 
import subprocess
import boto3


# In[4]:


def sql_connect(end, user, password, port,schema):
    
    engine = db.create_engine(f'mysql+pymysql://{user}:{password}@{end}:{port}/{schema}')
    return engine

connection = sql_connect('lambda-pr.crsu08qay9nu.ap-south-1.rds.amazonaws.com', 'admin', '12345678', 3306, 'superstore')


    
#Creating a the most purchase from customers 
sql =  'SELECT CustomerID, ProductID, SUM(Sales) AS most_pur FROM orders GROUP BY CustomerID ORDER BY most_pur DESC LIMIT 10;'
        

#reading the sql 
df = pd.read_sql(sql, con=connection)


# In[5]:


#Reading the dataframe
df


# In[6]:


#Saving the dataframe from sql to a json file
df.to_json('result.json')


# In[7]:


df[["CustomerID"]].head()


# In[8]:


df[["CustomerID"]].to_json('cus_id.json')


# In[12]:


bucket='lambda-pr'
folder='input'


subprocess.call(['aws','s3','cp','cus_id.json', 's3://lambda-pr/input/cus_id.json'])


# s3://lambda-pr/input/cus_id.json


# In[ ]:




