package com.project.smarthouse.controller;

import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Event;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.service.DeviceService;
import com.project.smarthouse.service.ActionService;
import com.project.smarthouse.repository.DeviceRepository;
import com.project.smarthouse.repository.EventRepository;
import com.project.smarthouse.repository.RoomRepository;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import static com.project.smarthouse.SortingHelper.getSortedRooms;

@RestController
@RequestMapping("/api/devices")
public class DeviceController {
    @Autowired
    private DeviceService deviceService;

    @Autowired
    private ActionService actionService;

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @GetMapping("/{id}")
    public ResponseEntity<Device> getDeviceById(@PathVariable Long id) {
        return deviceService.getDeviceById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("{deviceId}/events")
    public ResponseEntity<Event> createEvent(@PathVariable Long deviceId, @RequestBody Event event) {
        Device device = deviceRepository.findById(deviceId)
                .orElseThrow(() -> new RuntimeException("Device not found"));

        Room room = roomRepository.findById(device.getRoom().getRoomId())
                .orElseThrow(() -> new RuntimeException("Room not found"));

        device.setRoom(room);
        event.setDevice(device);
        Event savedEvent = eventRepository.save(event);

        //actionService.evaluateSensorDataAndAct(deviceId);

        return ResponseEntity.ok(savedEvent);
    }

    @PutMapping("/{deviceId}")
    public ResponseEntity<Device> updateDevice(@PathVariable Long deviceId, @RequestBody Device deviceDetails) {
        Device device = deviceRepository.findById(deviceId)
                .orElseThrow(() -> new RuntimeException("Device not found"));

        device.setType(deviceDetails.getType());
        device.setStatus(deviceDetails.getStatus());
        device.setNumLevel(deviceDetails.getNumLevel());
        
        final Device updatedDevice = deviceRepository.save(device);

        actionService.evaluateSensorDataAndAct(device.getRoom().getRoomId());
        publishToRoomsTopic();
        return ResponseEntity.ok(updatedDevice);
    }

    private void publishToRoomsTopic() {
        simpMessagingTemplate.convertAndSend("/topic/rooms", getSortedRooms(roomRepository));
    }

}
