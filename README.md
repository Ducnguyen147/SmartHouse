# SmartHouse System

## Overview

The SmartHouse system represents an innovative approach to home automation. This system facilitates real-time monitoring and control over various home devices and sensors, providing a sophisticated yet user-friendly smart home experience.

The SmartHouse system further enriches the user experience by adding an external simulator to the mobile application. This system feature allows users to monitor the status of all connected devices in real time and manage devices such as lights, heaters and security systems in the home through an integrated app. The app is designed to be intuitive and easy to use, making smart home management simple and convenient for everyone. By choosing SmartHouse, you're choosing a smarter, more intuitive way to manage your home's technology so that control is truly at your fingertips. 

## Workflow

### Backend (Spring Boot)
#### Core Components

- **SmartHouseSystem**: Acts as the central hub for managing operations and interactions. It integrates with all other components to ensure smooth operation.
- **EventPool**: Manages concurrent access to event data, serving as a central repository for events detected by sensors.
- **ConsequencePool**: Stores actions or outcomes resulting from events for execution.
- **Monitor**: Observes the smart home state, detecting events and forwarding them to the EventPool.
- **Reactor**: Watches the EventPool for events and triggers corresponding actions in the ConsequencePool.
- **Sensor and Actuator Interfaces**: Define the operations for sensors and actuators, including data collection and action execution.

#### Database Design

- Store and manage data related to Rooms, Sensors, Events, and Actions. Ensure scalability and efficient querying for real-time processing.

#### API Design

- **Event Management**: Endpoints for creating, retrieving, and managing events.
- **Action Execution**: Endpoints to trigger and manage actions based on events.
- **Sensor Data Collection**: Endpoints for sensors to send data.
- **User Management**: Authentication and authorization for users to interact with the system through the UI.

### Mobile UI and External Simulator
#### Core Features


#### Workflow Integration



#### Integration and Workflow

- **User Interaction**: Through the React frontend or mobile app, users send commands or simulate events for specific rooms.
- **Event Detection and Processing**: Sensors detect changes and send data to the Monitor, which generates events into the EventPool. The Reactor watches for these events and initiates actions.
- **Action Execution**: Actuators receive instructions from the ConsequencePool and perform actions, influencing room states.
- **Continuous Monitoring**: The Monitor continuously tracks environmental factors using specialized sensors, adjusting system actions accordingly.
