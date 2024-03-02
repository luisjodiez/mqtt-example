import json
import os
import boto3
from dotenv import load_dotenv
from collections import Counter
import decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return str(o)
        return super().default(o)

load_dotenv()
dynamodb = boto3.resource('dynamodb', 
                            region_name=os.environ.get('REGION'), 
                            aws_access_key_id=os.environ.get('APIKEY'), 
                            aws_secret_access_key=os.environ.get('SECRETKEY'))

def lambda_handler(event, context):
    if event['rawPath'] == '/metrics':
        response = json.loads(metrics())
    elif event['rawPath'] == '/':
        response = [{k: v} for k, v in info().items()]
    else:
        response = ['Invalid path']
    print(response)
    body = '\n'.join([json.dumps(item, cls=DecimalEncoder) for item in response])
    return {
        'statusCode': 200,
        'body': body
    }

def metrics():
    table = dynamodb.Table('error_table')
    items = table.scan()['Items']
    return json.dumps(items, cls=DecimalEncoder)

def info():
    table = dynamodb.Table('mqtt_table')
    items = table.scan()['Items']
    key_counts = Counter(item['Key'] for item in items)
    return dict(key_counts)
