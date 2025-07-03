FROM python:3.10-slim

# Install system dependencies for mediapipe & opencv
RUN apt-get update && apt-get install -y \
    ffmpeg libsm6 libxext6 libgl1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Railway sets PORT env var
EXPOSE 8080

# Increase gunicorn timeout to handle ResNet50 cold start
CMD exec gunicorn --bind :$PORT --timeout 120 app:app
