package com.project.smarthouse.repository;

import com.project.smarthouse.model.Action;
import com.project.smarthouse.model.Event;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    List<Event> findAllByDevice_Room_RoomIdAndEventType(Long roomId, String eventType);
    Optional<Event> findByDevice_DeviceId(Long deviceId);
}
