// package com.project.smarthouse.service;

// import com.project.smarthouse.model.Device;
// import com.project.smarthouse.model.Room;
// import com.project.smarthouse.repository.DeviceRepository;
// import com.project.smarthouse.repository.RoomRepository;

// import java.util.Optional;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Service;

// @Service
// public class KitchenService {

//     private final RoomRepository roomRepository;
//     private final DeviceRepository deviceRepository;

//     @Autowired
//     public KitchenService(RoomRepository roomRepository, DeviceRepository deviceRepository) {
//         this.roomRepository = roomRepository;
//         this.deviceRepository = deviceRepository;
//     }

//     public void controlKitchenLight() {
//         Room kitchenRoom = roomRepository.findByName("Kitchen");
//         if (kitchenRoom != null) {
//             Device kitchenLight = deviceRepository.findByRoomAndType(kitchenRoom, "Light");
//             if (kitchenLight != null) {
//                 kitchenLight.setStatus(turnOn); // turnOn为true时开灯，turnOn为false时关灯
//                 deviceRepository.save(kitchenLight);
//             }
//         }
//     }

//     private boolean checkBrightness() {
//         Optional<Device> optionalBrightnessSensor = deviceRepository.findByType("BrightnessSensor");
//         if (optionalBrightnessSensor.isPresent()) {
//             Device brightnessSensor = optionalBrightnessSensor.get();
//             int brightnessLevel = brightnessSensor.getNumLevel();
    
//             final int BRIGHTNESS_THRESHOLD = 500;
        
//             return brightnessLevel < BRIGHTNESS_THRESHOLD;
//         }
//         return false;
//     }

//     private boolean checkOccupancy() {
//         Device occupancySensor = deviceRepository.findByType("OccupancySensor");
//         if (occupancySensor != null) {
//             return occupancySensor.getStatus();
//         }
//         return false;
//     }
    
// }
