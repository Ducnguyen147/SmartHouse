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
    "model": "mistralai/Mistral-Nemo-Base-2407",
    "user_query": "I need to sleep now",
    "max_new_tokens": 200,
    "stream": false
}
```
. Environment variable:
export API_KEY=xxxJIgbmpUqCCwWvNaVhOhzXtWCUXLddOrReTxxx


