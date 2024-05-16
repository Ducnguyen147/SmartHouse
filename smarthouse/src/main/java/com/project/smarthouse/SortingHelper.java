package com.project.smarthouse;

import com.project.smarthouse.model.Room;
import org.springframework.data.domain.Sort;
import com.project.smarthouse.repository.RoomRepository;

public class SortingHelper {
    public static java.util.List<Room> getSortedRooms(RoomRepository roomRepository) {

        final java.util.List<Room> rooms = roomRepository.findAll(Sort.by(Sort.Direction.ASC, "roomId"));
        for (Room room : rooms) {
            room.getDevices().sort((d1, d2) -> (int) (d1.getDeviceId() - d2.getDeviceId()));
        }
        return rooms;
    }
}
