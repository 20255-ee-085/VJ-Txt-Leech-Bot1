FROM python:3.10.8-slim-buster

# Install system dependencies and ffmpeg in a single layer
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        musl-dev \
        python3-pip \
        ffmpeg \
        aria2 \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# Copy the rest of the application
COPY . .

# Verify ffmpeg installation and set PATH
ENV PATH="/usr/bin:${PATH}"
RUN which ffmpeg && ffmpeg -version

# Command to run the application
CMD gunicorn app:app & python3 main.py
