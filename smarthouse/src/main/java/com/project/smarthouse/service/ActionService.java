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
        lightLogic(room);  
        windowLogic(room);  
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
        } else if (device.getType().equals("OxygenSensor")) {
            event.setEventType("detectedOxygenLevel");
            event.setValue(String.valueOf(room.getOxygenLevel()));
        } else if (device.getType().equals("LightBulb")) {
            event.setEventType("switchLight");
        } else if (device.getType().equals("Window")) {
            event.setEventType("changeWindowStatus");
        }
        event.setTimestamp(new Timestamp(System.currentTimeMillis()));
        eventRepository.save(event);

        return event;
    }

    private void windowLogic(Room room) {
        Device oxyDevice = room.getDevices().stream()
                .filter(d -> "OxygenSensor".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("OxygenSensor not found"));
        oxyDevice.setStatus(true);

        Device window = room.getDevices().stream()
                .filter(d -> "Window".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Window not found"));

        float oxygenLevel = getLatestOxygenLevel(room);
        Event oxyEvent = setEvent(oxyDevice.getDeviceId(), oxyDevice, room);

        boolean windowStatus = shouldWindowOpen(oxygenLevel);
        window.setStatus(windowStatus);

        // Action triggered
        Action action = actionRepository.findByDevice_DeviceId(window.getDeviceId())
        .orElse(new Action());
        action.setDevice(window);
        action.setActionType(windowStatus ? "windowOpen" : "windowClose");
        action.setStatus("completed");
        action.setTimestamp(new Timestamp(System.currentTimeMillis()));
        actionRepository.save(action);

        Event windowEvent = setEvent(window.getDeviceId(), window, room);

        windowEvent.setValue(windowStatus ? "true" : "false");
        eventRepository.save(windowEvent);
    }

    private void lightLogic(Room room) {
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

    private int getLatestBrightness(Room room) {
        return room.getBrightness();
    }

    private int getLatestOccupancy(Room room) {
        return room.getOccupancy();
    }

    private float getLatestOxygenLevel(Room room) {
        return room.getOxygenLevel();
    }

    private boolean shouldLightBeOn(int brightness, int occupancy) {
        if (brightness > 90) return false;
        if (brightness <= 90 && occupancy == 0) return false;
        return brightness <= 90 && occupancy > 0;
    }

    private boolean shouldWindowOpen(float oxygenLevel) {
        if (oxygenLevel < 21) return true;
        return false;
    }
}
