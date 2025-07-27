from confluent_kafka import Consumer, KafkaException
import json

class KafkaJsonConsumer:
    def __init__(self, bootstrap_servers: str, topic: str, group_id: str):
        self.topic = topic
        self.consumer = Consumer({
            'bootstrap.servers': bootstrap_servers,
            'group.id': group_id,
            'auto.offset.reset': 'earliest'
        })

    def listen(self):
        self.consumer.subscribe([self.topic])
        print(f"📡 Subscribed to topic: {self.topic}")
        try:
            while True:
                msg = self.consumer.poll(1.0)
                if msg is None:
                    continue
                if msg.error():
                    raise KafkaException(msg.error())
                value = json.loads(msg.value().decode('utf-8'))
                print(f"📥 Received: {value}")
        except KeyboardInterrupt:
            print("🛑 Stopped by user.")
        finally:
            self.consumer.close()

if __name__ == "__main__":
    consumer = KafkaJsonConsumer("localhost:9092", "pharma-message-topic", "my-python-group")
    consumer.listen()
