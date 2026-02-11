import paho.mqtt.client as mqtt

class MQTTClient:
    def __init__(self, host, port, on_message):
        self.client = mqtt.Client()
        self.client.on_message = on_message
        self.client.connect(host, port, 60)
        self.client.loop_start()

    def subscribe(self, topic):
        self.client.subscribe(topic)

    def publish(self, topic, payload):
        self.client.publish(topic, payload)
