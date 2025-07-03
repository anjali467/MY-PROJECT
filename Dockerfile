FROM python:3.10-slim

# Install system libs for mediapipe & opencv
RUN apt-get update && apt-get install -y \
    ffmpeg libsm6 libxext6 libgl1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Cloud Run uses PORT env var
EXPOSE 8080

# Increase gunicorn timeout to avoid startup kill
CMD exec gunicorn --bind :$PORT --timeout 120 app:app
