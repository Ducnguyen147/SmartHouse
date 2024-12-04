# pylint: disable=too-few-public-methods
import os, requests
from flask import Flask, request, jsonify
from flask_restx import Api, Resource, fields
from huggingface_hub import InferenceClient

app = Flask(__name__)
api = Api(app, version='1.0', title='SmartHouse LLM API',
          description='An API to interact with the SmartHouse Language Model')

ns = api.namespace('llm', description='Language Model operations')

# Define the expected input model for Swagger documentation
text_gen_input = api.model('TextGenerationInput', {
    'model': fields.String(required=True, description='Model ID for text generation'),
    'prompt': fields.String(required=True, description='Prompt text to generate from'),
    'max_new_tokens': fields.Integer(required=False, default=50,
                                     description='Max number of new tokens to generate'),
    'stream': fields.Boolean(required=False, default=False,
                             description='Whether to stream the output'),
})

# Define the response model for Swagger documentation
text_gen_output = api.model('TextGenerationOutput', {
    'generated_text': fields.String(description='The generated text from the model')
})

def parse_response(response_text):
    # Extract the actions from between square brackets
    actions = response_text.split("],")
    result = []
    
    for action in actions:
        # Clean up the string and split by '/'
        clean_action = action.replace("[", "").replace("]", "").replace("Response:","").strip()
        if clean_action:
            device, status, room = clean_action.split("/")
            result.append({
                "device": device,
                "status": status,
                "room": room
            })
    
    return result

#client = InferenceClient(api_key="")  # Replace with your actual API key
client = InferenceClient(api_key=os.getenv("API_KEY"))
# Define the SmartHouse context
smart_house_context = """
You are an assistant controlling a SmartHouse with the following devices:
- **Rooms**:
  - Bedroom
  - Kitchen
  - Living Room
  - Bathroom
- **Devices**:
    - Window (Bedroom, Kitchen, Living Room, Bathroom): True/False for oxygen level regulating. If the room is lacking oxygen, the window should be opened.
    - AC (Bedroom, Kitchen, Living Room): True/False depends on the Temperature of the room. If the temperature is too hot, the AC should be turned on.
    - Heater (Bedroom, Kitchen, Living Room, Bathroom): True/False depends on the Temperature of the room. If the temperature is too cold, then the heater should be turned on.
    - LightBulb (Bedroom, Kitchen, Living Room, Bathroom): True/False. If the room is dark, the lightbulb should be turned on, if no one is in the room, it should be turned off.
    - BrightnessSensor (Bedroom, Kitchen, Living Room, Bathroom): True/False. To detect brightness in the room.
    - OccupancySensor (Bedroom, Kitchen, Living Room, Bathroom): True/False. To detect people in the room.
    - OxygenSensor (Bedroom, Kitchen, Living Room, Bathroom): True/False. To detect oxygen level.
    - TemperatureSensor (Bedroom, Kitchen, Living Room, Bathroom): True/False. To detect the room temperature.
    - ElectricPlug (Bedroom, Kitchen, Living Room, Bathroom): True/False
    - Stove (Kitchen): True/False and only available in the kitchen. The stove will be turned on if someone is about to cook.
    - VentilationSystem (Kitchen, Bathroom): True/False and only available in the kitchen and bathroom. It will be turned on if people cook in the kitchen or take a shower/ go to toilet in the bathroom.
- **Device behaviors**:
  - Remember if there is any change in brightness, occupancy, oxygen, temperature; you need to turn on the according sensors.
  - If no one is at home, remember to turn off all lightbulbs at home.
  - First example: I'm so cold in the bedroom. The response should be: [TemperatureSensor/True/Bedroom], [Heater/True/Bedroom]
  - Second example: I just played basketball, I'm so hot now and I will go to the living room. The response should be: [TemperatureSensor/True/Living Room], [AC/True/Living Room]
  - Third example: I will cook now. The response should be: [OccupancySensor/True/Kitchen], [Lightbulb/True/Kitchen], [VentilationSystem/True/Kitchen],[Stove/True/Kitchen], [Window/True/Kitchen]
  - ETC
"""

@ns.route('/text-generation')
class TextGeneration(Resource):
    """Resource for text generation using specified language models."""

    @ns.expect(text_gen_input)
    @ns.marshal_with(text_gen_output)
    def post(self):
        '''Generate text using the specified language model'''
        data = api.payload
        user_query = data['user_query']
        max_new_tokens = data.get('max_new_tokens', 50)
        stream = data.get('stream', False)
        prompt = f"""{smart_house_context}

User Query: "{user_query}"

As the assistant, analyze the query and provide the appropriate action or response considering the devices in corresponding rooms. The response should be in the format without futher explaination: [Device/Action/Room]. Do not add futher explaination.
"""
        try:
            # Generate text using the LLM
            response = client.text_generation(
                model=data['model'],
                prompt=prompt,
                max_new_tokens=max_new_tokens,
                stream=stream,
            )
            # Parse the response
            actions = parse_response(response)

            # Fetch all rooms and their devices
            rooms_response = requests.get('http://localhost:8080/api/rooms')
            rooms_data = rooms_response.json()
            rooms = rooms_data['data']

            # Create a room map with room names as keys
            room_map = {room['name'].lower(): room for room in rooms}

            # Helper function to normalize device type
            def normalize_device_type(device_type):
                return device_type.lower().replace(" ", "")

            # Iterate over actions and update the device states
            for action in actions:
                room_name = action['room'].lower()
                device_type = normalize_device_type(action['device'])
                status = action['status'].lower() == 'true'

                if room_name in room_map:
                    room = room_map[room_name]
                    for device in room['devices']:
                        if normalize_device_type(device['type']) == device_type:
                            device_id = device['deviceId']
                            # Update the device status via PUT request
                            update_payload = {
                                "type": device['type'],
                                "status": status,
                                "numLevel": device.get('numLevel', 0)
                            }
                            requests.put(f'http://localhost:8080/api/devices/{device_id}', json=update_payload)

            return {'generated_text': actions}, 200
        except (ValueError, ConnectionError, TimeoutError, requests.RequestException) as e:
            ns.abort(500, f"An error occurred: {e}")

room_output = api.model('RoomOutput', {
    'rooms': fields.List(fields.Nested(api.model('Room', {
        'roomId': fields.Integer(description='Room ID'),
        'name': fields.String(description='Room name')
    })))
})
@ns.route('/rooms')
class Rooms(Resource):
    """Resource for getting rooms information"""
    @ns.marshal_with(room_output)
    def get(self):
        '''Get rooms from external API'''
        try:
            response = requests.get('http://localhost:8080/api/rooms')
            rooms_data = response.json()
            
            # Extract only roomId and name
            filtered_rooms = [
                {'roomId': room['roomId'], 'name': room['name']} 
                for room in rooms_data['data']
            ]
            
            return {'rooms': filtered_rooms}, 200
            
        except requests.RequestException as e:
            ns.abort(500, f"Failed to fetch rooms: {str(e)}")

if __name__ == '__main__':
    app.run(debug=True)
