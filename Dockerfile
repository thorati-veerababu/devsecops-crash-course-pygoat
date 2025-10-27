FROM python:3.11-slim-bookworm

# Set work directory
WORKDIR /app

# 🧩 Install required system dependencies (without version pinning)
RUN apt-get update && apt-get install --no-install-recommends -y \
    dnsutils \
    libpq-dev \
    libpython3-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 🐍 Upgrade pip and install dependencies
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project
COPY . .

# ⚙️ Run Django migrations
RUN python3 manage.py migrate

# Expose port 8000
EXPOSE 8000

# Set working directory for app
WORKDIR /app/pygoat/

# 🚀 Start Gunicorn server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
