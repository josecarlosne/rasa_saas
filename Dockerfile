FROM python:3.10-slim

# Build deps for some wheels (ujson, httptools, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends         build-essential gcc &&         rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip &&         pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Make scripts executable
RUN chmod +x start.sh start_actions.sh

# For local docker run (Render injects $PORT)
EXPOSE 8000

# Default: run the Rasa server
CMD ["./start.sh"]
