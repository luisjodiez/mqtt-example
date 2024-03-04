import json
import boto3
from dotenv import load_dotenv
import os
import paho.mqtt.client as mqtt

class MqttConsumer:
    def __init__(self, broker_url, username, password, dynamodb):
        self.broker_url = broker_url
        self.username = username
        self.password = password
        self.client = mqtt.Client()
        self.client.username_pw_set(username, password)
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        self.error_table = dynamodb.Table('error_table')
        self.mqtt_table = dynamodb.Table('mqtt_table')

    def on_connect(self, client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT broker")
            self.client.subscribe("topic")
        else:
            print("Failed to connect to MQTT broker")

    def on_message(self, client, userdata, msg):
        try:
            payload = json.loads(msg.payload)
            timestamp = payload.get('TimeStamp') # Damn caps
            for key,value in payload.items():
                if key != 'timestamp':
                    item = {
                        'Key': key,
                        'Value': value,
                        'Timestamp': timestamp
                    }
                    try:
                        self.mqtt_table.put_item(Item=item)
                    except Exception as e:
                        print("Error writing to DynamoDB:", str(e))
                        self.error_table.update_item(
                            Key={'Metric': 'mqtt_dynamodb_error'},
                            UpdateExpression='SET Value = Value + :incr',
                            ExpressionAttributeValues={':incr': 1}
                        )
        except Exception as e:
            print("Error processing message:", str(e))
            self.error_table.update_item(
                Key={'Metric': 'mqtt_subs_error'},
                UpdateExpression='SET Value = Value + :incr',
                ExpressionAttributeValues={':incr': 1}
            )

    def connect(self):
        self.client.tls_set()
        self.client.connect(self.broker_url, 8883, 60)
        self.client.loop_forever()

    def disconnect(self):
        self.client.loop_stop()
        self.client.disconnect()


if __name__ == "__main__":
    load_dotenv()
    broker_url = os.environ.get('BROKER')
    username = os.environ.get('USERNAME')
    password = os.environ.get('PASSWORD')
    dynamo = boto3.resource('dynamodb',
                            region_name=os.environ.get('REGION'),
                            aws_access_key_id=os.environ.get('APIKEY'),
                            aws_secret_access_key=os.environ.get('SECRETKEY'))
    consumer = MqttConsumer(broker_url, username, password, dynamo)
    print("Created consumer. Starting consumer...")
    consumer.connect()