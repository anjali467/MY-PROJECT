# Use official Python image
FROM python:3.8.10

# Install system dependencies needed by mediapipe and others
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files into the container
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the port your app will run on (Render sets PORT env var)
EXPOSE 10000

# Run the app with gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:10000", "app:app"]
