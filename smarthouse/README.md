# How to run the application

## Requirements

- **Java version**: Version 21.
- **Database**: Download PostgreSQL to your local computer.
- **Create DB**: Create database called `smart_house` in your local machine. 
    - `createdb smart_house`
- **Create User**: 
    - `create user -s group2`
- **Create Password**:
    - `psql postgres`
    - `ALTER USER group2 WITH PASSWORD 'password';`
- **IDE**: Depends on you choice. e.g., VS Code, Eclipse, etc.

## How to run

- **Go to correct folder**: cd smarthouse
- **Run the project**: Go to SmarthouseApplication.java and run the project using 'Start' button.
- **Testing db connection**: Check if the tables are correctly created in your database `smart_house`

## API
### Room & Device
- **Create Room & Device**: `[POST] http://localhost:8080/api/rooms`
- **Kitchen**:
{
    "name": "Kitchen",
    "description": "50m2 kitchen space with modern equipments.",
    "brightness": 0,
    "occupancy": 0,
    "devices": [
        {
            "type": "BrightnessSensor",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "LightBulb",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "OccupancySensor",
            "status": false,
            "numLevel": 0
        }
    ]
}

### Events
- **Create Event**: `[POST] http://localhost:8080/api/devices/[deviceId]/events`
- **Light Bulp**:
{
    "eventType": "lightDetected",
    "timestamp": "2024-03-26T14:30:45",
    "value": "60"
},
{
    "eventType": "peopleDetected",
    "timestamp": "2024-03-26T15:31:45",
    "value": "2"
},
{
    "eventType": "switchLight",
    "timestamp": "2024-03-26T19:35:45",
    "value": "true"
}
