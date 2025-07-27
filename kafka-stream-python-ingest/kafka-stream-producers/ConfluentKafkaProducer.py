from confluent_kafka import Producer
import json
import time

class ConfluentKafkaProducer:
    def __init__(self, bootstrap_servers: str, topic: str):
        self.topic = topic
        self.producer = Producer({'bootstrap.servers': bootstrap_servers})

    def delivery_report(self, err, msg):
        if err is not None:
            print(f"Delivery failed: {err}")
        else:
            print(f"Delivered to {msg.topic()} [{msg.partition()}]")

    def send(self, key: str, value: dict):
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
    producer = ConfluentKafkaProducer("localhost:9092", "pharma-message-topic")

    try:
        for i in range(5):
            message = {"id": i, "content": f"Hello Kafka {i}"}
            producer.send(key=str(i), value=message)
            time.sleep(1)
    finally:
        producer.flush()