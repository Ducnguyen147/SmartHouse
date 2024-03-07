package com.project.smarthouse.model;

import jakarta.persistence.*;

@Entity
@Table(name = "events") 
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String type; // e.g., 'lightDetected', 'noOccupancy'
    private String details;

    public Event() {}

    public Event(String type, String details) {
        this.type = type;
        this.details = details;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
