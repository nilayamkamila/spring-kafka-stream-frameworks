package org.pharma.spring.kafka.controller;

import org.pharma.spring.kafka.model.Message;
import org.pharma.spring.kafka.producer.ProducerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/messages")
public class MessageController {

    @Autowired
    private ProducerService producerService;

    @PostMapping
    public String send(@RequestBody Message message) {
        producerService.sendMessage(message);
        return "Message Sent!";
    }
}
