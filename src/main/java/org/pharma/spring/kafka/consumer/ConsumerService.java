package org.pharma.spring.kafka.consumer;

import org.pharma.spring.kafka.model.Message;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class ConsumerService {

    @KafkaListener(topics = "demo-topic", groupId = "demo-group")
    public void listen(Message message) {
        System.out.println("Received Message: " + message.getContent());
    }

    @KafkaListener(topics = "common-secured-message-topic", groupId = "demo-group")
    public void listenMessage(Message message) {
        System.out.println("Received Message: " + message.getContent());
    }
}
