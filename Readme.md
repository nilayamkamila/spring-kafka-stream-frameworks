#Unsecured Kafka Server Configuration

```bash
cd kafka-common-environments
./kafka-run-utils.sh
```
The above command will start the Kafka server with the default configuration and the Consumer through docker.
To Start Unsecured Kafka Server for the Producer please run the below command
Please see the topic name is `common-message-topic`

```
KAFKA_TOPIC_NAME="common-message-topic" && KAFKA_CONTAINER_ID=$(docker ps --filter "name=kafka-common-environments-kafka" --format "{{.ID}}") && docker exec -it $KAFKA_CONTAINER_ID kafka-console-producer --broker-list localhost:9092 --topic $KAFKA_TOPIC_NAME
```
To configure unsecured kafka server communication from the Java code, please review the application.yaml below code
Please note, the port number is `9092` for unsecured communication and the topic name is `common-message-topic`
SSL related properties not required.

#Secured Kafka Server Configuration
```
./secured-kafka-run-utils.sh
please note the ./generate-configure-common-certs.sh is the first execution to generate the certificates that is included in the ./secured-kafka-run-utils.sh script
```
The above command will start the Kafka secured server with the default configuration and the Consumer through docker. The above command also runs the consumer in the background.
To Start secured Kafka Server for the Producer please run the below command. Please see the topic name is `common-secured-message-topic`
To produce the messages to the secured Kafka server, you need to use the `kafka-console-producer` command with the appropriate SSL configuration.
```
KAFKA_TOPIC_NAME="common-secured-message-topic" && KAFKA_CONTAINER_ID=$(docker ps --filter "name=kafka-common-environments-kafka" --format "{{.ID}}") && docker exec -it $KAFKA_CONTAINER_ID kafka-console-producer --broker-list localhost:9093 --topic $KAFKA_TOPIC_NAME --producer.config /etc/kafka/secrets/client.properties
```
To configure secured kafka server communication from the Java code, please review the application.yaml below code
Please note, the port number is `9093` for secured communication and the topic name is `common-secured-message-topic`

```yaml
properties:
      security.protocol: SSL
      ssl.truststore.location: kafka-common-environments/kafka-certs/kafka.server.truststore.jks
      ssl.truststore.password: password
      ssl.keystore.location: kafka-common-environments/kafka-certs/kafka.server.keystore.jks
      ssl.keystore.password: password
      ssl.key.password: password
```