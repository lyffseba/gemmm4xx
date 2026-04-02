# Gemma 4 on Modular MAX Engine with Mojo & HTMX 🔥

This repository demonstrates how to launch **Gemma 4** using the **Modular MAX Engine** for the fastest possible inference, paired with a minimalist **Mojo** backend and an **HTMX/TailwindCSS** frontend. 

It is designed to be highly economical, targeting deployments on affordable cloud GPU providers like **RunPod** (Option B architecture).

## 🚀 Architecture

*   **AI Engine:** [Modular MAX](https://www.modular.com/max) (`max-serve`) for state-of-the-art inference speed on NVIDIA/AMD GPUs.
*   **Backend Framework:** Pure [Mojo 🔥](https://www.modular.com/mojo) using `lightbug_http` to serve the web interface and proxy requests.
*   **Frontend:** A single-file, zero-build minimalist chat interface using [HTMX](https://htmx.org/) and TailwindCSS.
*   **Model:** Google Deepmind's Gemma 4 (Designed for GGUF quantized weights for economical VRAM usage).

## 💰 Why RunPod / Cloud Docker?

Deploying a 26B or 31B parameter model requires significant VRAM. By utilizing a Dockerized environment on RunPod, you can rent a dedicated RTX 3090 or RTX 4090 (24GB VRAM) for approximately $0.20 - $0.40 an hour. Using quantized (4-bit or 8-bit) GGUF formats allows Gemma 4 to fit comfortably in this environment while MAX Engine ensures blazing-fast generation speeds.

## 🛠️ How to Deploy (RunPod / Ubuntu GPU instance)

### 1. Clone the repository
```bash
git clone https://github.com/lyffseba/gemma4-max-mojo.git
cd gemma4-max-mojo
```

### 2. Build the Docker Image
The included `Dockerfile` automatically installs the Modular CLI, the MAX Engine, and sets up the Mojo environment.

```bash
docker build -t gemma4-max-mojo .
```

*Note: In a real deployment, you should update the `Dockerfile` to pull the specific Gemma 4 GGUF weights you wish to use from Hugging Face.*

### 3. Run the Container
```bash
docker run -p 8080:8080 --gpus all gemma4-max-mojo
```

### 4. Access the Interface
Navigate to `http://localhost:8080` (or your RunPod exposed port) in your browser. You will see the minimalist HTMX chat interface.

## 🧑‍💻 Local Development

If you have MAX and Mojo installed locally:

1. Clone `lightbug_http`:
```bash
git clone https://github.com/saviorand/lightbug_http.git
```
2. Run the server:
```bash
mojo run -I ./lightbug_http server.🔥
```

## 🤝 Contributing
Contributions are welcome! As the Mojo ecosystem and Modular MAX APIs evolve, this template can be expanded with native Mojo bindings for MAX.

## 📝 License
MIT License
