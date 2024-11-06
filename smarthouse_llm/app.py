# pylint: disable=too-few-public-methods
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

client = InferenceClient(api_key="hf_xxx")  # Replace with your actual API key

# Define the SmartHouse context
smart_house_context = """
You are an assistant controlling a SmartHouse with the following devices:
- **Rooms**:
  - Bedroom
  - Kitchen
  - Living Room
- **Devices**:
    - Window: Open/Closed for oxygen level regulating.
    - AC: On/Off depends on the Temperature of the room.
    - Heater: On/Off depends on the Temperature of the room.
    - LightBulb: On/Off.
    - BrightnessSensor: On/Off
    - OccupancySensor: On/Off
    - OxygenSensor: On/Off.
    - TemperatureSensor: On/Off.
    - ElectricPlug: On/Off.
    - Stove: On/Off and only available in the kitchen.
    - VentilationSystem: On/Off and only available in the kitchen.
- **Device behaviors** example:
  - First example: I'm so cold in the bedroom. The response should be: [Heater/On/Bedroom]
  - Second example: I just played basketball, I'm so hot now and I will go to the living room. The response should be: [AC/on/Living Room]
  - Third example: I will cook now. The response should be: [VentilationSystem/On/Kitchen],[Stove/On/Kitchen]
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
            response = client.text_generation(
                model=data['model'],
                prompt=prompt,
                max_new_tokens=max_new_tokens,
                stream=stream,
            )
            return {'generated_text': response}, 200
        except (ValueError, ConnectionError, TimeoutError) as e:
            ns.abort(500, f"An error occurred: {e}")

if __name__ == '__main__':
    app.run(debug=True)
