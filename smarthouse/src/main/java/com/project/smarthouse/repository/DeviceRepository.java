package com.project.smarthouse.repository;

import com.project.smarthouse.model.Device;
import com.project.smarthouse.model.Room;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
    // Optional<Device> findByType(String type);
    // Device findByRoomAndType(Room room, String type);
}
