# SmartHouse System

## Overview

The SmartHouse system represents an innovative approach to home automation, leveraging the power of AWS IoT to create a seamless, interconnected environment. This system facilitates real-time monitoring and control over various home devices and sensors, providing a sophisticated yet user-friendly smart home experience.

## Workflow

### Sensors and Data Collection

- **Sensors**: Various sensors (e.g., temperature, motion) within the smart home environment are simulated using the AWS IoT Device Simulator. These sensors are crucial for detecting changes in the environment and collecting data.
- **Data Transmission**: The collected data is transmitted to AWS IoT Core via MQTT messages. These messages are published to specific topics corresponding to each sensor type (e.g., `smartHouse/sensors/temperatureSensor`).

### Data Processing and Event Generation

- **Monitoring**: The Spring Boot application acts as the Monitor, subscribing to the sensor data topics within AWS IoT Core. This enables the application to process incoming data in real-time.
- **Event Generation**: Upon receiving sensor data, the Monitor evaluates this information to generate relevant events. These events are then added to the EventPool, signifying a change or action that needs to be addressed.

### Action Execution

- **Consequence Pool**: The Spring Boot application processes the events from the EventPool to determine appropriate actions, which are then stored in the ConsequencePool.
- **Publish Actions**: Actions determined as necessary are published back to AWS IoT Core, targeting specific actuator topics (e.g., `smartHouse/actuators/lights`).

### Actuators and Physical Actions

- **Actuator Subscription**: Actuators, which can be real devices or simulated in the AWS IoT Device Simulator, subscribe to their respective topics in AWS IoT Core.
- **Perform Actions**: Upon receiving a message, actuators perform the specified actions (e.g., turning lights on/off, adjusting the thermostat).

## Benefits

- **Real-time Interaction**: Immediate processing and reaction to environmental changes.
- **Scalability**: Easily add or modify sensors, actuators, and logic as the smart home evolves.
- **Customizability**: Tailor the system to meet specific needs and preferences.
- **Security**: Leverage AWS IoT Core's secure communication for data transmission and device interaction.

