1. Install Flask:
```bash
pip install flask flask_restx
```

2. End point:
```bash
http://localhost:5000/llm/text-generation
http://localhost:5000/llm/rooms

```

3. Request body:
```json
{
    "model": "mistralai/Mistral-7B-Instruct-v0.3",
    "user_query": "I'm going to sleep now.",
    "max_new_tokens": 1000,
    "stream": false
}
```
. Environment variable:
export API_KEY=xxxJIgbmpUqCCwWvNaVhOhzXtWCUXLddOrReTxxx


