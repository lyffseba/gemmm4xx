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
1. **The Native Cloud Setup (Recommended for Learning):** Manually installing MAX and running the Mojo client.
2. **The Docker Setup:** A one-click automated container deployment.

---

## 🛠️ Approach 1: The Native Cloud Setup (Step-by-Step)

This is the best way to learn how the Modular ecosystem works. We will rent a cheap GPU, install MAX, and run our Mojo code.

### Step 1: Rent a Cloud GPU
1. Go to [RunPod.io](https://www.runpod.io/).
2. Click **Deploy** -> **Secure Cloud**.
3. Select an **RTX 3090** or **RTX 4090** (24GB VRAM).
4. Use the default **RunPod PyTorch** image and Deploy.
5. Once running, click **Connect** -> **Connect to Web Terminal**.

### Step 2: Install Modular MAX Engine
In your RunPod terminal, install the engine:
```bash
curl -s https://get.modular.com | sh -
modular auth
modular install max
```

### Step 3: Start the Gemma 4 Server
Let `max-serve` handle downloading the model and starting the hyper-optimized inference server:
```bash
max-serve --model "google/gemma-4-26b-it" --port 8000
```
*(Leave this terminal running!)*

### Step 4: Run the Mojo Client
Open a **second terminal** in RunPod, clone this repo, and run the Mojo script to talk to Gemma 4:
```bash
git clone https://github.com/lyffseba/gemmm4xx.git
cd gemmm4xx
mojo run client.mojo
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
