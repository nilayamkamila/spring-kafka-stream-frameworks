docker-compose -f docker-compose-secured.yaml down
docker-compose -f docker-compose-secured.yaml up -d
KAFKA_CONTAINER_ID=$(docker ps --filter "name=kafka-common-environments-kafka" --format "{{.ID}}")
KAFKA_TOPIC_NAME="common-secured-message-topic"
KAFKA_CONSUMER_GROUP_NAME="common-message-console-group"
if [ -n "$KAFKA_CONTAINER_ID" ]; then
  echo "Kafka Container ID: $KAFKA_CONTAINER_ID"
  docker exec -it $KAFKA_CONTAINER_ID kafka-topics \
    --create --topic $KAFKA_TOPIC_NAME \
    --bootstrap-server localhost:9093 \
    --partitions 1 --replication-factor 1 \
    --command-config /etc/kafka/secrets/client.properties
  docker exec -it $KAFKA_CONTAINER_ID kafka-topics \
    --list --bootstrap-server localhost:9093 \
    --command-config /etc/kafka/secrets/client.properties
  docker exec -it $KAFKA_CONTAINER_ID kafka-broker-api-versions \
    --bootstrap-server localhost:9093 \
    --command-config /etc/kafka/secrets/client.properties
  docker exec -it $KAFKA_CONTAINER_ID kafka-console-consumer \
    --bootstrap-server localhost:9093 \
    --topic $KAFKA_TOPIC_NAME \
    --group $KAFKA_CONSUMER_GROUP_NAME --from-beginning \
    --consumer.config /etc/kafka/secrets/client.properties
  #KAFKA_TOPIC_NAME="common-secured-message-topic" && KAFKA_CONTAINER_ID=$(docker ps --filter "name=kafka-common-environments-kafka" --format "{{.ID}}") && docker exec -it $KAFKA_CONTAINER_ID kafka-console-producer --broker-list localhost:9093 --topic $KAFKA_TOPIC_NAME --producer.config /etc/kafka/secrets/client.properties
else
  echo "Kafka container not found."
  docker exec -it $KAFKA_CONTAINER_ID kafka-topics \
    --list --bootstrap-server localhost:9093 \
    --command-config /etc/kafka/secrets/client.properties
fi

