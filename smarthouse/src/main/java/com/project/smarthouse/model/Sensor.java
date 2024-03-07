package com.project.smarthouse.model;

import jakarta.persistence.*;

@Entity
@Table(name = "sensors") 
public class Sensor {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String type; //e.g., 'light', 'occupancy'
    private String location;  //e.g., 'kitchen'

    public Sensor() {}

    public Sensor(String type, String location) {
        this.type = type;
        this.location = location;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
