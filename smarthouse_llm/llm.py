from huggingface_hub import InferenceClient

client = InferenceClient(api_key="")  # Replace with your actual API key

try:
    response = client.text_generation(
        model="mistralai/Mistral-7B-Instruct-v0.3",
        prompt="What is the capital of France?",
        max_new_tokens=50,
        stream=False,
    )
    print(response)
except Exception as e:
    print(f"An error occurred: {e}")
