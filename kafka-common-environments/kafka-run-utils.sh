docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d
KAFKA_CONTAINER_ID=$(docker ps --filter "name=kafka-common-environments-kafka" --format "{{.ID}}")
KAFKA_TOPIC_NAME="common-message-topic"
KAFKA_CONSUMER_GROUP_NAME="common-message-console-group"
if [ -n "$KAFKA_CONTAINER_ID" ]; then
  echo "Kafka Container ID: $KAFKA_CONTAINER_ID"
  docker exec -it $KAFKA_CONTAINER_ID kafka-topics --create \
    --topic $KAFKA_TOPIC_NAME --bootstrap-server localhost:9092 \
    --partitions 1 --replication-factor 1
  docker exec -it $KAFKA_CONTAINER_ID \
    kafka-topics --list --bootstrap-server localhost:9092
  docker exec -it $KAFKA_CONTAINER_ID \
    kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --topic $KAFKA_TOPIC_NAME \
    --group $KAFKA_CONSUMER_GROUP_NAME \
    --from-beginning
#KAFKA_TOPIC_NAME="common-message-topic" && KAFKA_CONTAINER_ID=$(docker ps --filter "name=kafka-common-environments-kafka" --format "{{.ID}}") && docker exec -it $KAFKA_CONTAINER_ID kafka-console-producer --broker-list localhost:9092 --topic $KAFKA_TOPIC_NAME
else
  echo "Kafka container not found."
  docker exec -it $KAFKA_CONTAINER_ID \
    kafka-topics --list --bootstrap-server localhost:9092
fi