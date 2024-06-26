package com.project.smarthouse.repository;

import com.project.smarthouse.model.Action;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ActionRepository extends JpaRepository<Action, Long> {
    Optional<Action> findByDevice_DeviceId(Long deviceId);
}