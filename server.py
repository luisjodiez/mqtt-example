import json
import os
import boto3
from dotenv import load_dotenv
from collections import Counter

load_dotenv()
dynamodb = boto3.resource('dynamodb', 
                            region_name=os.environ.get('REGION'), 
                            aws_access_key_id=os.environ.get('APIKEY'), 
                            aws_secret_access_key=os.environ.get('SECRETKEY'))

def lambda_handler(event, context):
    if event['rawPath'] == '/metrics':
        body = metrics()
    elif event['rawPath'] == '/':
        body = info()
    else:
        body = 'Invalid path'
    return {
        'statusCode': 200,
        'body': json.dumps(body)
    }

def metrics():
    table = dynamodb.Table('error_table')
    items = table.scan()['Items']
    metrics = {item['MetricName']: item['Value'] for item in items}
    return json.dumps(metrics)

def info():
    table = dynamodb.Table('mqtt_table')
    items = table.scan()['Items']
    key_counts = Counter(item['Key'] for item in items)
    return json.dumps(dict(key_counts))

    