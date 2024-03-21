package com.project.smarthouse.model;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;

@Entity
@Table(name = "devices") 
public class Device {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long deviceId;
    @ManyToOne
    @JoinColumn(name = "roomId", nullable = false)
    private Room room;
    private String type;
    private Boolean status;
    private Integer numLevel;

    @OneToOne(cascade = CascadeType.ALL, mappedBy = "device", fetch = FetchType.LAZY)
    private Action action;

    @ManyToMany
    @JoinTable(
        name = "device_event",
        joinColumns = @JoinColumn(name = "deviceID"),
        inverseJoinColumns = @JoinColumn(name = "eventID")
    )
    private Set<Event> events = new HashSet<>();

    public Device() {}

    public Device(String type, Boolean status) {
        this.type = type;
        this.status = status;
    }

    // Getters and Setters
    public Long getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(Long deviceId) {
        this.deviceId = deviceId;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }
    
    public Integer getNumLevel() {
        return numLevel;
    }
    
    public void setNumLevel(Integer numLevel) {
        this.numLevel = numLevel;
    }
    
    public Set<Event> getEvents() {
        return events;
    }

    public void setEvents(Set<Event> events) {
        this.events = events;
    }
}
