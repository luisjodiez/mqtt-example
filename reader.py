import time
import random
import paho.mqtt.client as mqtt

def lambda_handler(event, context):
    file_path = "plc.log"
    broker_address = "1c0bdb311ba64e2397b72acfb50f55b1.s1.eu.hivemq.cloud"
    topic = "topic"
    read_file_and_publish(file_path, broker_address, topic)

def publish_message(client, topic, message):
    client.publish(topic, message)
    print(f"Published: {message}")

def read_file_and_publish(file_path, broker_address, topic):
    client = mqtt.Client()
    client.connect(broker_address)
    client.loop_start()

    with open(file_path, 'r') as file:
        for line in file:
            message = line.strip()
            publish_message(client, topic, message)
            time.sleep(random.uniform(0.1, 1))

    client.loop_stop()
    client.disconnect()
