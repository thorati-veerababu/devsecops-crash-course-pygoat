FROM python:3.11-slim-bookworm

WORKDIR /app

# Install dependencies needed for common Python builds (psycopg2, Pillow, etc.)
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        gcc \
        libpq-dev \
        libjpeg-dev \
        zlib1g-dev \
        dnsutils \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/root/.local/bin:$PATH"

# Upgrade pip, setuptools, wheel first
COPY requirements.txt .
RUN pip install --upgrade --no-cache-dir pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

RUN python manage.py migrate

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers=4", "pygoat.wsgi"]
