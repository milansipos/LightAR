import paho.mqtt.client as mqtt
import time

MQTT_BROKER = "127.0.0.1" 
MQTT_PORT = 1883
MQTT_TOPIC = "ar/light/cmd"

# This function runs when we successfully connect
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        client.subscribe(MQTT_TOPIC)
        print("Connected to mqtt")
        print(f"Subscribed to topic {MQTT_TOPIC}")
    else:
        print(f"Failed to connect, returned with code: {rc}")

def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    print(f"Topic: {msg.topic}")
    print(f"Message: {payload}")

client = mqtt.Client() 
client.on_connect = on_connect
client.on_message = on_message

try:
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
except Exception as e:
    print(f"Could not connect to MQTT Broker: {e}")
    exit(1)

client.loop_start() 
print("waiting for connection")