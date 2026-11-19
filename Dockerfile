# Slim base image, pinned to a minor Python version
FROM python:3.12-slim

# All app files live here
WORKDIR /app

# No .pyc files; log output straight to stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install dependencies first so this layer stays cached when only code changes
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code and version file
COPY hello_world.py VERSION ./

# Run as an unprivileged user
RUN useradd --create-home --uid 10001 appuser
USER appuser

# Port gunicorn listens on
EXPOSE 8000

# Mark the container unhealthy if /version stops responding
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/version', timeout=2)" || exit 1

# Serve the app with a production WSGI server
CMD ["gunicorn", "-b", "0.0.0.0:8000", "hello_world:app"]
