package org.pharma.spring.kafka.producer;

import org.pharma.spring.kafka.model.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class ProducerService {
    private static final String TOPIC = "demo-topic";
    private static final String PHARMA_MESSAGE_TOPIC = "common-secured-message-topic";

    @Autowired
    private KafkaTemplate<String, Message> kafkaTemplate;

    public void sendMessage(Message message) {
        kafkaTemplate.send(TOPIC, message);
        message.setContent("Pharma Message ("+new Date().toString()+"): " + message.getContent());
        kafkaTemplate.send(PHARMA_MESSAGE_TOPIC, message);
    }
}
