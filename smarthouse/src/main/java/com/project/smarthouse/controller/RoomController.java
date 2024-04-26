package com.project.smarthouse.controller;

import com.project.smarthouse.config.WebSocketConnection;
import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.repository.RoomRepository;
import com.project.smarthouse.repository.DeviceRepository;
import com.project.smarthouse.service.ActionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import java.util.ArrayList;
import java.util.Map;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private ActionService actionService;
    @GetMapping
    public ResponseEntity<Map<String, Object>> getRooms() {
        return ResponseEntity.ok(Map.of("data", roomRepository.findAll()));
    }

//    notify topics

    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @PostMapping
    public  ResponseEntity<Room> createRoom(@RequestBody Room room) {
        Room savedRoom = roomRepository.save(room);
        if (room.getDevices() != null) {
            for (Device device : room.getDevices()) {
                device.setRoom(savedRoom);
                deviceRepository.save(device);
            }
        }
        simpMessagingTemplate.convertAndSend("/topic/rooms", roomRepository.findAll());
        return ResponseEntity.ok(savedRoom);
    }




    @PutMapping("/{roomId}")
    public ResponseEntity<Room> updateRoom(@PathVariable Long roomId, @RequestBody Room roomDetails) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found with id " + roomId));

        room.setName(roomDetails.getName());
        room.setDescription(roomDetails.getDescription());
        room.setBrightness(roomDetails.getBrightness());
        room.setOccupancy(roomDetails.getOccupancy());
        room.setOxygenLevel(roomDetails.getOxygenLevel());
        room.setTemperature(roomDetails.getTemperature());

        final Room updatedRoom = roomRepository.save(room);

        actionService.evaluateSensorDataAndAct(roomId);
        simpMessagingTemplate.convertAndSend("/topic/rooms", roomRepository.findAll());

        return ResponseEntity.ok(updatedRoom);
    }
}