from kafka import KafkaProducer
import json
import time

class KafkaMessageProducer:
    def __init__(self, bootstrap_servers: str, topic: str):
        self.topic = topic
        self.producer = KafkaProducer(
            bootstrap_servers=bootstrap_servers,
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )

    def send(self, key: str, value: dict):
        print(f"Sending to {self.topic}: {value}")
        self.producer.send(self.topic, key=key.encode(), value=value)
        self.producer.flush()

    def close(self):
        self.producer.close()


if __name__ == "__main__":
    producer = KafkaMessageProducer(bootstrap_servers="localhost:9092", topic="pharma-message-topic")

    try:
        for i in range(5):
            message = {"id": i, "content": f"Hello Kafka {i}"}
            producer.send(key=str(i), value=message)
            time.sleep(1)
    finally:
        producer.close()