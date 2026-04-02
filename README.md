# Gemma 4 on Modular MAX Engine with Mojo & HTMX 🔥

This repository demonstrates how to launch **Gemma 4** using the **Modular MAX Engine** for the fastest possible inference, paired with a minimalist **Mojo** backend and an **HTMX/TailwindCSS** frontend. 

It is designed to be highly economical, targeting deployments on affordable cloud GPU providers like **RunPod**.

## 🚀 The Stack
*   **AI Engine:** [Modular MAX](https://www.modular.com/max) (`max-serve`) for state-of-the-art inference speed on NVIDIA/AMD GPUs.
*   **Backend Framework:** Pure [Mojo 🔥](https://www.modular.com/mojo) using `lightbug_http` to serve the web interface.
*   **Frontend:** A single-file, zero-build minimalist chat interface using [HTMX](https://htmx.org/) and TailwindCSS.
*   **Model:** Google Deepmind's Gemma 4.

## 🧠 Why this approach?
As announced in the [Modular Day Zero Launch](https://www.modular.com/blog/day-zero-launch-fastest-performance-for-gemma-4-on-nvidia-and-amd), running Gemma 4 on the MAX Engine yields up to 15% faster inference than vLLM. To do this economically, we rent a cloud GPU by the hour (RunPod) instead of buying a $10,000 graphics card.

There are two ways to run this project:
1. **The Native Cloud Setup (Recommended for Learning):** Manually installing MAX and running the Mojo client using `pixi`.
2. **The Docker Setup:** A one-click automated container deployment.

---

## 🛠️ Approach 1: The Native Cloud Setup (Step-by-Step)

This is the best way to learn how the Modular ecosystem works. We will use `pixi`, the officially recommended package manager for Modular, to ensure a clean, isolated environment.

### Step 1: Install Pixi
Pixi is a blazing fast package manager that sets up our Modular environment perfectly without messing with global system settings.
```bash
curl -fsSL https://pixi.sh/install.sh | sh
export PATH="$HOME/.pixi/bin:$PATH"
```

### Step 2: Clone & Initialize the Environment
We clone the code, initialize a new `pixi` project, and install `modular` and python `requests` (so Mojo can make HTTP calls via interop).
```bash
git clone https://github.com/lyffseba/gemmm4xx.git
cd gemmm4xx

pixi init max_env -c https://conda.modular.com/max-nightly/ -c conda-forge
cd max_env
pixi add modular requests openai
```

### Step 3: Start the MAX Server
Let `max-serve` handle downloading the model, compiling the high-performance graph, and starting the inference server.

*If you are on a Cloud GPU (RunPod):*
```bash
pixi run max serve --model "google/gemma-4-26b-it" --port 8000
```

*If you are testing locally on a CPU without a GPU (uses a smaller test model):*
```bash
pixi run max serve --model "Qwen/Qwen2.5-0.5B-Instruct" --devices cpu --quantization-encoding float32 --port 8000
```
*(Leave this terminal running! Wait until you see `🚀 Server ready on http://0.0.0.0:8000`)*

### Step 4: Run the Mojo Client
Open a **second terminal**, navigate to the `gemmm4xx/max_env` directory, and run the Mojo script to talk to the engine:
```bash
cd gemmm4xx/max_env
pixi run mojo run ../client.mojo
```

---

## 🐳 Approach 2: The Docker Deployment

If you want to run the full HTMX web-interface setup in a self-contained environment:

### 1. Build the Image
```bash
git clone https://github.com/lyffseba/gemmm4xx.git
cd gemmm4xx
docker build -t gemmm4xx .
```

### 2. Run the Container
```bash
docker run -p 8080:8080 --gpus all gemmm4xx
```

### 3. Access the Chat UI
Navigate to `http://localhost:8080` (or your RunPod exposed port) in your browser to chat with Gemma!
