from std.python import Python

def main() raises:
    print("🔥 Mojo Client connecting to MAX Engine (Gemma 4)...")
    
    # We use Python interop for HTTP requests as standard Mojo HTTP client is still experimental
    var requests = Python.import_module("requests")

    var url = "http://localhost:8000/v1/chat/completions"
    
    var headers = Python.dict()
    headers["Content-Type"] = "application/json"
    
    var messages = Python.list()
    var msg = Python.dict()
    msg["role"] = "user"
    msg["content"] = "Explain quantum computing in one simple sentence."
    messages.append(msg)
    
    var payload = Python.dict()
    # If we are testing on a CPU with limited RAM, we use a smaller model like Qwen2.5-0.5B
    # If on a GPU, this should be "google/gemma-4-26b-it"
    payload["model"] = "Qwen/Qwen2.5-0.5B-Instruct"
    payload["messages"] = messages
    payload["temperature"] = 0.7

    print("Sending prompt to MAX Engine...")
    var response = requests.post(url, headers=headers, json=payload)
    
    if response.status_code == 200:
        var data = response.json()
        var reply = data["choices"][0]["message"]["content"]
        print("\n🤖 AI says:\n", reply)
    else:
        print("Error:", response.status_code, response.text)
