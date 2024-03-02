import os
import boto3
from flask import Flask, jsonify
from dotenv import load_dotenv
from collections import Counter

load_dotenv()
app = Flask(__name__)

dynamodb = boto3.resource('dynamodb', 
                            region_name=os.environ.get('REGION'), 
                            aws_access_key_id=os.environ.get('APIKEY'), 
                            aws_secret_access_key=os.environ.get('SECRETKEY'))

@app.route('/metrics')
def metrics():
    table = dynamodb.Table('MetricsTable')
    items = table.scan()['Items']
    metrics = {item['MetricName']: item['Value'] for item in items}
    return jsonify(metrics)

@app.route('/info')
def info():
    table = dynamodb.Table('InfoTable')
    items = table.scan()['Items']
    key_counts = Counter(item['Key'] for item in items)
    return jsonify(dict(key_counts))

if __name__ == '__main__':
    app.run()