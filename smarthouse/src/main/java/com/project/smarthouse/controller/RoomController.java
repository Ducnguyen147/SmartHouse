package com.project.smarthouse.controller;

import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.repository.RoomRepository;
import com.project.smarthouse.repository.DeviceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    @PostMapping
    public ResponseEntity<Room> createRoom(@RequestBody Room room) {
        Room savedRoom = roomRepository.save(room);
        if (room.getDevices() != null) {
            for (Device device : room.getDevices()) {
                device.setRoom(savedRoom);
                deviceRepository.save(device);
            }
        }

        return ResponseEntity.ok(savedRoom);
    }
}