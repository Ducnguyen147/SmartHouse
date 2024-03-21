package com.project.smarthouse.service;

import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Room;
import com.project.smarthouse.repository.DeviceRepository;
import com.project.smarthouse.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class KitchenService {

    private final RoomRepository roomRepository;
    private final DeviceRepository deviceRepository;

    @Autowired
    public KitchenService(RoomRepository roomRepository, DeviceRepository deviceRepository) {
        this.roomRepository = roomRepository;
        this.deviceRepository = deviceRepository;
    }

    public void controlKitchenLight() {
        Room kitchenRoom = roomRepository.findByName("Kitchen");
        if (kitchenRoom != null) {
            // 获取厨房灯光设备信息
            Device kitchenLight = deviceRepository.findByRoomAndType(kitchenRoom, "Light");
            if (kitchenLight != null) {
            
                kitchenLight.setStatus(turnOn); // turnOn为true时开灯，turnOn为false时关灯
                // 更新数据库中的设备状态Update status
                deviceRepository.save(kitchenLight);
            }
        }
    }

    private boolean checkBrightness() {
        // light sensor
        Device brightnessSensor = deviceRepository.findByType("BrightnessSensor");
        if (brightnessSensor != null) {
            // Light intensity is expressed as a numerical value
            int brightnessLevel = brightnessSensor.getNumLevel();
        
            // Set the light threshold, e.g.500
            final int BRIGHTNESS_THRESHOLD = 500;
        
            // Returns true if the light level is below the threshold(indicating that the light needs to be switched on)
            return brightnessLevel < BRIGHTNESS_THRESHOLD;
        }
        // 如果没有找到传感器或其他任何原因，可以根据实际情况返回默认值
        // 这里假设在没有读数时默认不需要开灯It's off by default.
        return false;
    }

    private boolean checkOccupancy() {
        // 查找特定的占用情况传感器设备
        Device occupancySensor = deviceRepository.findByType("OccupancySensor");
        if (occupancySensor != null) {
            // 假设设备的状态为布尔类型，表示是否检测到人员占用
            // 直接返回该状态作为方法的返回值
            return occupancySensor.getStatus();
        }
        // 如果没有找到传感器或出于其他原因无法获取状态，可以根据实际需要返回默认值
        // 这里默认为false，表示没有人
        return false;
    }
    
}
