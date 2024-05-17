# SmartHouse System

## Overview

The SmartHouse system represents an innovative approach to home automation. This system facilitates real-time monitoring and control over various home devices and sensors, providing a sophisticated yet user-friendly smart home experience.

The SmartHouse system further enriches the user experience by adding an external simulator to the mobile application. This system feature allows users to monitor the status of all connected devices in real time and manage devices such as lights, heaters and security systems in the home through an integrated app. The app is designed to be intuitive and easy to use, making smart home management simple and convenient for everyone. By choosing SmartHouse, you're choosing a smarter, more intuitive way to manage your home's technology so that control is truly at your fingertips. 

## High-level architecture

The SmartHouse system is architecturally divided into several key components, each responsible for different aspects of the system’s functionality. These components include the mobile UI, the backend services, the database, and the external simulator. The system is built on a microservices architecture to ensure scalability and resilience. Each service communicates through well-defined APIs, allowing for efficient data exchange and processing.
<img width="850" alt="image" src="https://github.com/Ducnguyen147/SmartHouse/assets/102163508/f01eeeb2-fc0e-464d-ab4f-97f440d5db5d">

## Workflow

### Backend (Spring Boot)
For our Smart House system, the entry point is those parameters that are detected by sensors: 
- **Brightness**: Detected by Brightness sensor. Basically, this parameter can be understood as environment lightness (The brightness of the room without the effects of light devices in the room in percentage) in which based on these parameters, the Light Bulb can be adjusted accordingly.  
- **Occupancy**: Number of people in the room. 
- **Oxygen level**: Oxygen percentage in the room. The default value is 21%. 
- **Temperature**: Temperature value detected in the room 
- By the changing of these parameters with certain effects from other devices, specific actions can be triggered for specific devices. 
  
  #### System Workflow
- The simulator will provide simulated value changes for these parameters. 
- After these parameters are changed, events are created for sensors that detected those changes (E.g., Occupancy Detected, Light Detected, etc.) 
- Based on certain events, the actions will be performed accordingly for the working equipment (not including the sensors, e.g., Switch Light, Switch Ventilation Fan, etc.). 
- After the specific actions are posted, the states of devices are altered accordingly.

#### Actions in details:
- Sensors: 
  - **Brightness Sensor**: If the Brightness parameter of the specific room is changed, this sensor will turn on and detects the change. 
  - **Occupancy Sensor**:  If the Occupancy parameter is changed, this sensor will be turned on and detects the change. 
  - **Oxygen Sensor**: If the Oxygen Level parameter is changed, this sensor will be turned on and detects the change. 
  - **Temperature Sensor**: If the Temperature parameter is changed, this sensor will be turned on and detects the change. 

- Other equipment: 
  - **Light Bulb**: For automatic action, the light bulbs are turned on if the brightness of the room is less than or equal to 90% and there is at least one person in the room. Otherwise, the light bulbs will be turned on. 
  - **Window**:  For automatic action, if the oxygen level is below 21% which is detected by the Oxygen Level, the windows can have an option to be automatically opened by our system. 
  - **AC and Heater**: For automatic action, if the temperature detected by the Temperature Sensor in the room is less than 22oC then heater is turned on or if the temperature is more than 27oC then the AC is turned on. If the temperature is reached 22-27oC range, then both AC and Heaters can be turned off automatically by our system. 
  - **Ventilation System**: For the automatic action, the Ventilation System is added specifically only for the Kitchen. It will be automatically turned on if the Stove is turned on. Regarding the Stove, there is no automatic action for this device and the users should turn on/ off the Stove by themself. 
  - **Door Lock**: For the automatic action, the automatic door lock has only been implemented in the living room. If no one is in the house, then the lock for this main door will automatically be activated. 
  - **Electrical Plug**: For the automatic action, the electrical plug will be automatically turned on is there is anyone in the room and be automatically turned off if everyone leaves the room. 

#### Database Design

- Store and manage data related to Rooms, Devices, Events, and Actions. Ensure scalability and efficient querying for real-time processing.
- Interfaces with a PostgreSQL database to store and retrieve data on device states, user settings, and historical sensor data.
- Architecture:
  - <img width="583" alt="image" src="https://github.com/Ducnguyen147/SmartHouse/assets/102163508/1cbe5621-32a5-49c2-ab8c-f912e38d73aa">

#### API Design

- Manages all incoming and outgoing API requests, including device status updates, room configurations, and user commands.

### Mobile UI and External Simulator
#### Mobile UI
The user interface of the SmartHouse app is designed to be intuitive and user-friendly, enabling users to interact with their home environment effortlessly. 
- It allows users to: 
  - **Control Devices**: Turn devices on and off, adjust settings, and monitor their current state. 
  - **Simulate Scenarios**: Use the simulator to create various environmental conditions to see how the system responds. 
  - **Receive Notifications**: Get alerts about significant changes or required actions, enhancing the security and responsiveness of the system. 

#### Simulator
The external simulator within the mobile app is a pivotal feature for both demonstration and testing purposes. It mimics real-world changes in the environment, such as fluctuations in temperature, light, and occupancy, allowing for:

  - **Testing: Developers** and testers can simulate various scenarios to see how the system reacts without the need for physical setups. 
  - **User Training:** New users can familiarize themselves with the system features and functionalities in a controlled environment before applying settings to their actual devices.

  ### Repository 
  - **Main Repository**: [SmartHouse System](https://github.com/Ducnguyen147/SmartHouse/)
  - **Mobile UI and External Simulator Repository**: [SmartHouse Mobile App](https://github.com/yossefEl/smarthome-elte)
  This refined documentation aims to provide clear and concise information avout the SmartHouse system, ensureing easy of understanding for new users and developers.
  - Detailed instructions on how to set up and run the SmartHouse application can be found here: [README.md](https://github.com/Ducnguyen147/SmartHouse/blob/main/smarthouse/README.md)

