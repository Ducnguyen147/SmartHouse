package com.project.smarthouse.service;

import com.project.smarthouse.model.Action;
import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Event;
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
    private DeviceRepository deviceRepository;
    
    @Autowired
    private ActionRepository actionRepository;

    @Autowired
    private EventRepository eventRepository;

    public void evaluateSensorDataAndAct(Long deviceId) {
        Device device = deviceRepository.findById(deviceId)
                .orElseThrow(() -> new RuntimeException("Device not found"));

        if (!"LightBulb".equals(device.getType())) {
            return;
        }

        int brightness = getLatestBrightness(device.getRoom().getRoomId());
        int occupancy = getLatestOccupancy(device.getRoom().getRoomId());

        boolean lightStatus = shouldLightBeOn(brightness, occupancy);
        Action action = actionRepository.findByDevice_DeviceId(deviceId)
        .orElse(new Action());
    
        action.setDevice(device);

        action.setActionType(lightStatus ? "lightOn" : "lightOff");
        action.setStatus("completed");
        action.setTimestamp(new Timestamp(System.currentTimeMillis()));

        actionRepository.save(action);

        device.setStatus(lightStatus);
        deviceRepository.save(device);
    }

    private int getLatestBrightness(Long roomId) {
        List<Event> events = eventRepository.findAllByDevice_Room_RoomIdAndEventType(roomId, "lightDetected");
        return events.stream()
                    .max(Comparator.comparing(Event::getTimestamp))
                    .map(event -> Integer.parseInt(event.getValue()))
                    .orElse(0);
    }

    private int getLatestOccupancy(Long roomId) {
        List<Event> events = eventRepository.findAllByDevice_Room_RoomIdAndEventType(roomId, "peopleDetected");
        return events.stream()
                    .max(Comparator.comparing(Event::getTimestamp))
                    .map(event -> Integer.parseInt(event.getValue()))
                    .orElse(0); 
    }

    private boolean shouldLightBeOn(int brightness, int occupancy) {
        if (brightness > 500) return false;
        if (brightness <= 500 && occupancy == 0) return false;
        return brightness <= 500 && occupancy > 0;
    }
}
