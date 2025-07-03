# Use a slim Python base image (smaller, faster)
FROM python:3.9-slim

# Set environment variables to prevent Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy requirements first (for Docker caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose port (Cloud Run uses PORT env var, but this is harmless)
EXPOSE 8080

# Command to run your Flask app (using gunicorn for production)
# Adjust "app:app" if your Flask file is named differently (here it's app.py with Flask app named `app`)
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app
