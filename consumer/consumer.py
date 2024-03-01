import paho.mqtt.client as mqtt
from flask import Flask, jsonify
import json

app = Flask(__name__)

# MQTT settings
mqtt_broker = "1c0bdb311ba64e2397b72acfb50f55b1.s1.eu.hivemq.cloud"
mqtt_port = 8883
mqtt_topic = "topic"

# Metrics
requests_per_second = 0
errors = 0

# Info
message_count = {}

def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT broker")
    client.subscribe(mqtt_topic)

def on_message(client, userdata, msg):
    global requests_per_second, errors, message_count

    # Update metrics
    requests_per_second += 1

    # Process message
    try:
        payload = msg.payload.decode("utf-8")
        # Update info
        if msg.topic in message_count:
            message_count[msg.topic] += 1
        else:
            message_count[msg.topic] = 1
    except Exception as e:
        # Update metrics
        errors += 1
        print(f"Error processing message: {e}")

@app.route("/metrics")
def get_metrics():
    return jsonify({
        "requests_per_second": requests_per_second,
        "errors": errors
    })

@app.route("/info")
def get_info():
    return jsonify(message_count)

if __name__ == "__main__":
    # Start MQTT client
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(mqtt_broker, mqtt_port, 60)

    # Start Flask app
    app.run()