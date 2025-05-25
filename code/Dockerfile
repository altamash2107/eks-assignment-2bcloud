# Use a minimal, secure base image with a specific version
FROM python:3.9-slim-bullseye

# Set environment variables to prevent Python from writing .pyc files and to buffer logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_HOME=/app

# Set working directory
WORKDIR $APP_HOME


# Install pip dependencies
COPY req.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r req.txt

# Copy app source code
COPY . .

# Create non-root user and change ownership
RUN adduser --disabled-password --gecos '' appuser \
    && chown -R appuser:appuser $APP_HOME

# Switch to non-root user
USER appuser

# Expose the app port
EXPOSE 3000

# Use exec form to start the app (recommended for signal handling)
CMD ["python3", "main.py"]
