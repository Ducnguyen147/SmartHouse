package com.project.smarthouse.model;

import jakarta.persistence.*;
import java.sql.Timestamp;
import java.util.Set;

@Entity
@Table(name = "actions")
public class Action {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long actionId;
    @OneToOne
    @JoinColumn(name = "deviceId", nullable = false, unique = true)
    private Device device;
    @OneToMany(mappedBy = "action", fetch = FetchType.LAZY)
    private Set<Event> events;
    private String actionType;
    private String status;
    private Timestamp timestamp;

    public Action() {}

    public Action(Device device, String actionType, String status, Timestamp timestamp) {
        this.device = device;
        this.actionType = actionType;
        this.status = status;
        this.timestamp = timestamp;
    }

    public Long getActionId() {
        return actionId;
    }

    public void setActionId(Long actionId) {
        this.actionId = actionId;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
}
