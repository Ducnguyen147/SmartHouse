# SmartHouse System

## Overview

The SmartHouse system represents an innovative approach to home automation, leveraging the power of external simulator to create a seamless, interconnected environment. This system facilitates real-time monitoring and control over various home devices and sensors, providing a sophisticated yet user-friendly smart home experience.

External simulator is a mobile application.

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

### Frontend (React)
#### User Interface Components

- **Dashboard**: For real-time monitoring of the smart home state, including sensor readings and ongoing actions.
- **Event and Action Logs**: Display history and details of events and actions.
- **Room Management**: Interfaces for users to interact with and control individual rooms and devices.
- **Settings**: For configuring system behaviors, user preferences, and sensor thresholds.

#### Interaction Flow

- Utilize WebSocket or long-polling for real-time updates to the dashboard.
- Implement Redux or Context API for state management across the React app.
- Design responsive components for a seamless experience across devices.

### Mobile Application (External Simulator)
#### Core Features

- **Simple Room Control**: Allow users to simulate room interactions, such as changing temperature or simulating movement.
- **Event Simulation**: Users can generate events to see how the system reacts in real-time.
- **View System State**: Display current sensor values, active events, and ongoing actions.

#### Workflow Integration

- The mobile app communicates with the Spring Boot backend via RESTful APIs for event simulation and state viewing.
- Utilize push notifications or a similar mechanism to update the mobile app with real-time changes in the system state.

#### Integration and Workflow

- **User Interaction**: Through the React frontend or mobile app, users send commands or simulate events for specific rooms.
- **Event Detection and Processing**: Sensors detect changes and send data to the Monitor, which generates events into the EventPool. The Reactor watches for these events and initiates actions.
- **Action Execution**: Actuators receive instructions from the ConsequencePool and perform actions, influencing room states.
- **Continuous Monitoring**: The Monitor continuously tracks environmental factors using specialized sensors, adjusting system actions accordingly.

#### Development Considerations

- **Security**: Implement robust security measures, including HTTPS, authentication/authorization, and data encryption.
- **Scalability**: Design the backend to efficiently handle increasing data volumes from sensors and user interactions.
- **User Experience**: Ensure the UI is intuitive and provides immediate feedback to user actions.