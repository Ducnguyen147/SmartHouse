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
- **Connect to database**:
    - `psql -U group2 postgres`
- **List all database**:
    - `\l`
- **Select the database**:
    - `\c db_name`
- **List all tables**:
    - `\dt`
- **IDE**: Depends on you choice. e.g., VS Code, Eclipse, etc.

## How to run

- **Go to correct folder**: cd smarthouse
- **Run the project**: Go to SmarthouseApplication.java and run the project using 'Start' button.
- **Testing db connection**: Check if the tables are correctly created in your database `smart_house`

## API
### Room & Device
- **Create Room & Device**: `[POST] http://localhost:8080/api/rooms`
{
    "name": "Kitchen",
    "description": "50m2 kitchen space with modern equipments.",
    "brightness": 0,
    "occupancy": 0,
    "oxygenLevel": 21,
    "temperature": 21,
    "livingRoom": false,
    "devices": [
        {
            "type": "BrightnessSensor",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "OccupancySensor",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "OxygenSensor",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "TemperatureSensor",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "LightBulb",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "Window",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "AC",
            "status": false,
            "numLevel": 0
        },
        {
            "type": "Heater",
            "status": false,
            "numLevel": 0
        }, 
        {
            "type": "Stove",
            "status": false,
            "numLevel": 0
        }, 
        {
            "type": "VentilationSystem",
            "status": false,
            "numLevel": 0
        }, 
        {
            "type": "ElectricPlug",
            "status": false,
            "numLevel": 0
        }
    ]
}

- **Update Room**: `[PUT] http://localhost:8080/api/rooms/1`
{
    "name": "Kitchen",
    "description": "50m2 kitchen space with modern equipments.",
    "brightness": 75,
    "occupancy": 2,
    "oxygenLevel": 20,
    "temperature": 20,
    "livingRoom": false
}

- **Update Device**: `[PUT] http://localhost:8080/api/devices/9`
{
    "type": "Stove",
    "status": true,
    "numLevel": 2
}

### Events && Actions
- Events and Actions are automatically adjusted based on the room properties (After changing room's parameters like occupancy, temperature, etc.).

