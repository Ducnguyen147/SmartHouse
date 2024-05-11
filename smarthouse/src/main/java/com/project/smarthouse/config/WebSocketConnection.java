package com.project.smarthouse.config;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.time.LocalDateTime;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import org.springframework.web.socket.CloseStatus;

public class WebSocketConnection  extends TextWebSocketHandler {

    private static final Logger log = LoggerFactory.getLogger(WebSocketConnection.class);

    private static final Gson gson = new GsonBuilder().create();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        log.info("connected with the websocket client : " + session.getId());
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        JsonObject parsedMessage = gson.fromJson(message.getPayload(), JsonObject.class);

        log.info("The message got from the client is " + parsedMessage);

        JsonObject responseMessage = new JsonObject();
        responseMessage.addProperty("response", "Your response was recorded by the server");
        responseMessage.addProperty("messageReceivedtime", LocalDateTime.now().toLocalDate().toString());
        int max = 100;
        int min = 20;
        responseMessage.addProperty("randomNo", (int) Math.floor(Math.random() * (max - min + 1) + min));

        session.sendMessage(new TextMessage(responseMessage.toString())); //sending message back to the client
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        log.info("connection closed from the websocket client : " + session.getId());
    }
}

//list me the imports

//import org.springframework.web.socket.CloseStatus;
//import org.springframework.web.socket.TextMessage;
//import org.springframework.web.socket.WebSocketSession;
//import org.springframework.web.socket.handler.TextWebSocketHandler;
