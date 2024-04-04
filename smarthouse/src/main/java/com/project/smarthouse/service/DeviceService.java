package com.project.smarthouse.service;

import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Event;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.repository.DeviceRepository;
import com.project.smarthouse.repository.RoomRepository;
import com.project.smarthouse.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class DeviceService {
    @Autowired
    private DeviceRepository deviceRepository;
    private RoomRepository roomRepository;
    private EventRepository eventRepository;

    public Optional<Device> getDeviceById(Long id) {
        return deviceRepository.findById(id);
    }

    public Optional<Event> updateEvent(Long deviceId, Long eventId, Event updatedEvent) {
        return deviceRepository.findById(deviceId)
                .flatMap(device -> {
                    return device.getEvents().stream()
                            .filter(event -> event.getId().equals(eventId))
                            .findFirst()
                            .map(event -> {
                                event.setEventType(updatedEvent.getEventType());
                                event.setValue(updatedEvent.getValue());
                                eventRepository.save(event);
                                return event;
                            });
                });
    }

}
