# Use a small, secure base image
FROM python:3.11-slim-bookworm

# Set working directory
WORKDIR /app

# Install system dependencies (for psycopg2 and DNS utilities)
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        gcc \
        libpq-dev \
        dnsutils \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/root/.local/bin:$PATH"

# Upgrade pip and install dependencies efficiently
COPY requirements.txt .
RUN pip install --upgrade --no-cache-dir pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy only necessary files
COPY . .

# Expose the application port
EXPOSE 8000

# Apply database migrations
RUN python manage.py migrate

# Default command (use gunicorn for production)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers=4", "pygoat.wsgi"]
