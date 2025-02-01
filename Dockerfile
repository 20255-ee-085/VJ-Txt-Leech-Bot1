thon:3.10.8-slim-buster

# Install system dependencies
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        musl-dev \
        ffmpeg \
        aria2 \
        python3-pip \
        software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

# Command to run the application
CMD gunicorn app:app & python3 main.py
