import os, ssl
from paho.mqtt import client as paho_client

def lambda_handler(event, context):
    file_path = "plc.log"
    broker_address = "1c0bdb311ba64e2397b72acfb50f55b1.s1.eu.hivemq.cloud"
    topic = "topic"
    username = os.getenv('USERNAME')
    password = os.getenv('PASSWORD')
    read_file_and_publish(file_path, broker_address, topic, username, password)

def publish_message(client, topic, message):
    client.publish(topic, message)
    print(f"Published: {message}")

def on_connect(client, userdata, flags, rc, properties):
    print(f"Connected with result code {rc}")

def read_file_and_publish(file_path, broker_address, topic, username, password):
    client = paho_client.Client(paho_client.CallbackAPIVersion.VERSION2)
    sslSettings = ssl.SSLContext(paho_client.ssl.PROTOCOL_TLS)
    client.tls_set_context(sslSettings)
    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker_address, 8883)
    client.loop_start()

    with open(file_path, 'r') as file:
        for line in file:
            message = line.strip()
            publish_message(client, topic, message)

    client.loop_stop()