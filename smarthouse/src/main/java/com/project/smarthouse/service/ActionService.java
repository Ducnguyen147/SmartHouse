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
        acHeaterLogic(room);
        doorLogic(room);
        plugLogic(room);  
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
        } else if (device.getType().equals("TemperatureSensor")) {
            event.setEventType("detectTemperatureLevel");
            event.setValue(String.valueOf(room.getTemperature()));
        } else if (device.getType().equals("AC")) {
            event.setEventType("changeAcStatus");
        } else if (device.getType().equals("Heater")) {
            event.setEventType("changeHeaterStatus");
        } else if (device.getType().equals("DoorLock")) {
            event.setEventType("changeDoorLockStatus");
        } else if (device.getType().equals("ElectricPlug")) {
            event.setEventType("changeElectricPlugStatus");
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
        if (brightness > 70) return false;
        if (brightness <= 70 && occupancy == 0) return false;
        return brightness <= 70 && occupancy > 0;
    }

    private boolean shouldWindowOpen(float oxygenLevel) {
        if (oxygenLevel < 21) return true;
        return false;
    }
    public void controlRoomVentilationSystem(Long roomId, boolean turnOn, int fanSpeed) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
   
       
        Device ventilationSystem = room.getDevices().stream()
                .filter(d -> "VentilationSystem".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("VentilationSystem not found in room with ID: " + roomId));
   
       
        ventilationSystem.setStatus(turnOn);
        ventilationSystem.setNumLevel(fanSpeed);
        deviceRepository.save(ventilationSystem);
   
       
        Action action = new Action();
        action.setDevice(ventilationSystem);
        action.setActionType(turnOn ? "VentilationOn" : "VentilationOff");
        action.setStatus("completed");
        action.setTimestamp(new Timestamp(System.currentTimeMillis()));
        actionRepository.save(action);
    }
    public void acHeaterLogic(Room room) {
        Device temperatureSensor = room.getDevices().stream()
                .filter(d -> "TemperatureSensor".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("TemperatureSensor not found"));
    
        float temperature = getLatestTemperature(room);
        Event temperatureEvent = setEvent(temperatureSensor.getDeviceId(), temperatureSensor, room);
    
        Device ac = room.getDevices().stream()
                .filter(d -> "AC".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("AC not found"));
    
        Device heater = room.getDevices().stream()
                .filter(d -> "Heater".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Heater not found"));
    
        controlACAndHeater(room, ac, heater, temperature);
    
        Action acAction = actionRepository.findByDevice_DeviceId(ac.getDeviceId())
                .orElse(new Action());
        acAction.setDevice(ac);
        acAction.setActionType(ac.getStatus() ? "ACOn" : "ACOff");
        acAction.setStatus("completed");
        acAction.setTimestamp(new Timestamp(System.currentTimeMillis()));
        actionRepository.save(acAction);
    
        Action heaterAction = actionRepository.findByDevice_DeviceId(heater.getDeviceId())
                .orElse(new Action());
        heaterAction.setDevice(heater);
        heaterAction.setActionType(heater.getStatus() ? "HeaterOn" : "HeaterOff");
        heaterAction.setStatus("completed");
        heaterAction.setTimestamp(new Timestamp(System.currentTimeMillis()));
        actionRepository.save(heaterAction);
    }
    
    private float getLatestTemperature(Room room) {
        return room.getTemperature();
    }
    
    public void controlACAndHeater(Room room, Device ac, Device heater, float temperature) {
        float heaterThreshold = 22; 
        float acThreshold = 27;     
    
        if (temperature < heaterThreshold) {
            ac.setStatus(false);
            heater.setStatus(true);
        } else if (temperature > acThreshold) {
            ac.setStatus(true);
            heater.setStatus(false);
        } else {
            ac.setStatus(false);
            heater.setStatus(false);
        }
        deviceRepository.save(ac);
        deviceRepository.save(heater);
    }

    private void doorLogic(Room room) {
        Device occDevice = room.getDevices().stream()
                .filter(d -> "OccupancySensor".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("OccupancySensor not found"));
        occDevice.setStatus(true);
        int totalOccupancy = calculateTotalOccupancy();
        Room livingRoom = roomRepository.findByRoomName("Living room");
        if (livingRoom != null) {
            Device doorLock = livingRoom.getDevices().stream()
                    .filter(d -> "DoorLock".equals(d.getType()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("DoorLock not found"));

            boolean doorLockStatus = shouldDoorBeLocked(totalOccupancy);
            Event doorLockEvent = setEvent(doorLock.getDeviceId(), doorLock, livingRoom);

            Action action = actionRepository.findByDevice_DeviceId(doorLock.getDeviceId())
                    .orElse(new Action());
            action.setDevice(doorLock);
            action.setActionType(doorLockStatus ? "doorLocked" : "doorUnlocked");
            action.setStatus("completed");
            action.setTimestamp(new Timestamp(System.currentTimeMillis()));
            actionRepository.save(action);

            Event lockEvent = setEvent(doorLock.getDeviceId(), doorLock, livingRoom);

            lockEvent.setValue(doorLockStatus ? "true" : "false");
            eventRepository.save(lockEvent);
        }
    }

    private int calculateTotalOccupancy() {
        int totalOccupancy = 0;
        Iterable<Room> rooms = roomRepository.findAll();
        for (Room currentRoom : rooms) {
            totalOccupancy += currentRoom.getOccupancy();
        }
        return totalOccupancy;
    }

    private boolean shouldDoorBeLocked(int totalOccupancy) {
        return totalOccupancy == 0;
    }

    private void plugLogic(Room room) {
        Device occDevice = room.getDevices().stream()
                .filter(d -> "OccupancySensor".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("OccupancySensor not found"));
        occDevice.setStatus(true);
                
        Device electricPlug = room.getDevices().stream()
                .filter(d -> "ElectricPlug".equals(d.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("ElectricPlug not found"));
        
        int occupancy = getLatestOccupancy(room);
        Event occEvent = setEvent(occDevice.getDeviceId(), occDevice, room);
        
        boolean electricPlugStatus = shouldPlugBeOn(occupancy);
        electricPlug.setStatus(electricPlugStatus);

        Action action = actionRepository.findByDevice_DeviceId(electricPlug.getDeviceId())
                .orElse(new Action());
        action.setDevice(electricPlug);
        action.setActionType(electricPlugStatus ? "plugOn" : "plugOff");
        action.setStatus("completed");
        action.setTimestamp(new Timestamp(System.currentTimeMillis()));
        actionRepository.save(action);
        
        Event plugEvent = setEvent(electricPlug.getDeviceId(), electricPlug, room);
        plugEvent.setValue(electricPlugStatus ? "true" : "false");
        eventRepository.save(plugEvent);
    }

    private int getLatestOccupancy(Room room) {
        return room.getOccupancy();
    }

    private boolean shouldPlugBeOn(int occupancy) {
        return occupancy > 0;
    }

    
}
