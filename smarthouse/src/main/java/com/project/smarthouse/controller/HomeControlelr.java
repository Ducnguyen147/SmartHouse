package com.project.smarthouse.controller;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/")
public class HomeControlelr {

    @GetMapping("/")
    public String home() {
        return "Welcome to Smart House";
    }

//    error
    @GetMapping("/error")
    public String error() {
        return "Error";
    }


}
