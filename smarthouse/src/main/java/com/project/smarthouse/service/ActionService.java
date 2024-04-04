package com.project.smarthouse.service;

import com.project.smarthouse.model.Action;
import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Event;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.repository.RoomRepository;
import com.project.smarthouse.repository.ActionRepository;
import com.project.smarthouse.repository.DeviceRepository;
import com.project.smarthouse.repository.EventRepository;

import java.sql.Timestamp;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ActionService {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private DeviceRepository deviceRepository;
    
    @Autowired
    private ActionRepository actionRepository;

    @Autowired
    private EventRepository eventRepository;

    public void evaluateSensorDataAndAct(Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
        Device occDevice = room.getDevices().stream()
                .filter(d -> "OccupancySensor".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("OccupancySensor not found"));
        occDevice.setStatus(true);

        Device brDevice = room.getDevices().stream()
                .filter(d -> "BrightnessSensor".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("BrightnessSensor not found"));
        brDevice.setStatus(true);

        Device lightBulb = room.getDevices().stream()
                .filter(d -> "LightBulb".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("LightBulb not found"));
        
        int brightness = getLatestBrightness(room);
        Event brEvent = setEvent(brDevice.getDeviceId(), brDevice, room);
        
        int occupancy = getLatestOccupancy(room);
        Event occEvent = setEvent(occDevice.getDeviceId(), occDevice, room);

        boolean lightStatus = shouldLightBeOn(brightness, occupancy);
        lightBulb.setStatus(lightStatus);

        // Action triggered
        Action action = actionRepository.findByDevice_DeviceId(lightBulb.getDeviceId())
        .orElse(new Action());
    
        action.setDevice(lightBulb);

        action.setActionType(lightStatus ? "lightOn" : "lightOff");
        action.setStatus("completed");
        action.setTimestamp(new Timestamp(System.currentTimeMillis()));

        actionRepository.save(action);

        Event lightEvent = setEvent(lightBulb.getDeviceId(), lightBulb, room);

        lightEvent.setValue(lightStatus ? "true" : "false");
        eventRepository.save(lightEvent);
               
    }
    

    private Event setEvent(Long deviceId, Device device, Room room) {
        Event event = eventRepository.findByDevice_DeviceId(deviceId)
        .orElse(new Event());
        event.setDevice(device);
        if (device.getType().equals("OccupancySensor")) {
            event.setEventType("occupancyDetected");
            event.setValue(String.valueOf(room.getOccupancy()));
        } else if (device.getType().equals("BrightnessSensor")) {
            event.setEventType("lightDetected");
            event.setValue(String.valueOf(room.getBrightness()));
        } else if (device.getType().equals("LightBulb")) {
            event.setEventType("switchLight");
        }
        event.setTimestamp(new Timestamp(System.currentTimeMillis()));
        eventRepository.save(event);

        return event;
    }

    private int getLatestBrightness(Room room) {
        return room.getBrightness();
    }

    private int getLatestOccupancy(Room room) {
        return room.getOccupancy();
    }

    private boolean shouldLightBeOn(int brightness, int occupancy) {
        if (brightness > 70) return false;
        if (brightness <= 70 && occupancy == 0) return false;
        return brightness <= 70 && occupancy > 0;
    }
}
