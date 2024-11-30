package com.project.smarthouse.controller;

import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Event;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.service.DeviceService;
import com.project.smarthouse.service.ActionService;
import com.project.smarthouse.repository.DeviceRepository;
import com.project.smarthouse.repository.EventRepository;
import com.project.smarthouse.repository.RoomRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;
import java.util.List;

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

    private static final Logger log = LoggerFactory.getLogger(DeviceController.class);

    @GetMapping("/{id}")
    public ResponseEntity<Device> getDeviceById(@PathVariable Long id) {
        return deviceService.getDeviceById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/room/{roomId}")
    public ResponseEntity<List<Device>> getDevicesByRoomId(@PathVariable Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
                
        List<Device> devices = room.getDevices();
        return ResponseEntity.ok(devices);
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

        // actionService.evaluateSensorDataAndAct(device.getRoom().getRoomId());
        actionService.controlRoomVentilationSystem(device.getRoom());
        publishToRoomsTopic();
        return ResponseEntity.ok(updatedDevice);
    }

    private void publishToRoomsTopic() {
        log.info("[Sockett] Device update.");
        simpMessagingTemplate.convertAndSend("/topic/rooms", getSortedRooms(roomRepository));
    }

}
