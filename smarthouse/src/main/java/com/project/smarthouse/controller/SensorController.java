package com.project.smarthouse.controller;

import com.project.smarthouse.service.DeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sensors")
public class SensorController {

    @Autowired
    private DeviceService deviceService;

    @PostMapping("/occupancy")
    public ResponseEntity<String> handleOccupancySensor(@RequestParam boolean isOccupied, @RequestParam Long roomId) {
        return deviceService.handleOccupancySensor(isOccupied, roomId);
    }

}
