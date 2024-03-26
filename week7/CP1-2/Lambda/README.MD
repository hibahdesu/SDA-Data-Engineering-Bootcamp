The Lambda function is called **de-demo-read-inventory-uoload2snowflake** on WCD AWS account. The script file in this repo is call [lambdaFunctionDemo.py](https://github.com/WCD-DE/AE_project/blob/main/Students/Lambda/lambdaFunctionDemo.py)

read file from public S3 bucket. The bucket was updated every night by RDS. Every night a new Inventory.csv file is uploaded to the S3 bucket. The file has an fixed link: [https://de-materials-tpcds.s3.ca-central-1.amazonaws.com/inventory.csv](https://de-materials-tpcds.s3.ca-central-1.amazonaws.com/inventory.csv). 

The Lambda function will do the following steps:
1. attach a layer to the lamda. The layer contain the snowflake libary used for the lambda funciton. The step can be found from [here](https://github.com/WCD-DE/AE_project/blob/main/Students/Lambda/how%20to%20add%20layer%20to%20lambda%20in%20a%20quick%20way.txt) .
2. download the file "inventory.csv" from the [url](https://de-materials-tpcds.s3.ca-central-1.amazonaws.com/inventory.csv). 
3. on Snowflake:
  1). use the schema we want to use;
  2). create file format;
  3). create file stage;
  4). upload the file into the stage;
  5). copy the file from stage to table.

Be aware that in the demo lambda function, the the table in the Snowflake is not called Inventory, which it should, it is just try to make student to read and understand the script seriously. 
