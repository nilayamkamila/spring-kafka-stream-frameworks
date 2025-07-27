from confluent_kafka import Producer
import json

class KafkaTLSProducer:
    def __init__(self, bootstrap_server, topic):
        self.topic = topic
        self.producer = Producer({
            'bootstrap.servers': bootstrap_server,
            'security.protocol': 'SSL',
            'ssl.ca.location': '../../kafka-common-environments/kafka-certs/ca2.pem',
            'ssl.certificate.location': '../../kafka-common-environments/kafka-certs/client2.pem',
            'ssl.key.location': '../../kafka-common-environments/kafka-certs/client2.key',
            #'ssl.key.password': 'password',  # if encrypted, else omit
        })

    def delivery_report(self, err, msg):
        if err:
            print(f"❌ Message delivery failed: {err}")
        else:
            print(f"✅ Message delivered to {msg.topic()} [{msg.partition()}]")

    def send_message(self, key, value):
        self.producer.produce(
            topic=self.topic,
            key=key,
            value=json.dumps(value),
            callback=self.delivery_report
        )
        self.producer.poll(0)

    def flush(self):
        self.producer.flush()


if __name__ == "__main__":
    producer = KafkaTLSProducer("your.kafka.server:9093", "secure-topic")

    message = {"event": "secure-data", "status": "success"}
    producer.send_message(key="tls-key", value=message)

    producer.flush()
    print("All messages sent.")