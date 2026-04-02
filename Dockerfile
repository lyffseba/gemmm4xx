# Use RunPod's base PyTorch/CUDA image as it has drivers ready
FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

# Set non-interactive to avoid timezone prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Modular MAX and Mojo
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Modular CLI & MAX Engine
RUN curl -s https://get.modular.com | sh - && \
    modular auth --mutely && \
    modular install max

# Set up environment variables for Modular
ENV MODULAR_HOME="/root/.modular"
ENV PATH="/root/.modular/pkg/packages.modular.com_max/bin:$PATH"

# Create application directory
WORKDIR /app

# Download a Quantized Gemma 4 Model (e.g., 4-bit GGUF)
# Note: For production, we recommend using a volume in RunPod to avoid re-downloading
RUN mkdir -p /app/models && \
    echo "Downloading Gemma 4 model (Placeholder for actual wget/huggingface-cli command)..."
    # Example: wget https://huggingface.co/username/gemma-4-gguf/resolve/main/gemma-4-26b-q4.gguf -O /app/models/gemma4.gguf

# We need Lightbug for the Mojo web server
RUN git clone https://github.com/saviorand/lightbug_http.git /app/lightbug_http

# Copy our Mojo server code
COPY server.🔥 /app/server.🔥

# Create a startup script that runs max-serve in the background and the Mojo server in the foreground
RUN echo '#!/bin/bash\n\
# Start MAX Engine model server in the background (adjust args for actual model)\n\
# max-serve --model /app/models/gemma4.gguf --port 8000 &\n\
\n\
# Start the Mojo Web Frontend/Backend\n\
# We compile and run the Mojo server, linking the lightbug library\n\
export MODULAR_HOME="/root/.modular"\n\
export PATH="/root/.modular/pkg/packages.modular.com_max/bin:$PATH"\n\
\n\
echo "Starting Mojo Web Server..."\n\
# In a real environment, you might build it first: mojo build server.🔥 -I /app/lightbug_http\n\
mojo run -I /app/lightbug_http server.🔥\n\
' > /app/start.sh && chmod +x /app/start.sh

# Expose the port the Mojo server runs on
EXPOSE 8080

# Run the startup script
CMD ["/app/start.sh"]
