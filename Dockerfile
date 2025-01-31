# 1. Use an official Python runtime as a parent image
FROM python:3.11-slim

# 2. Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Set work directory
WORKDIR /app

# 4. Install system dependencies (optional)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 5. Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy project
COPY . .

# 7. Expose the port the app runs on
EXPOSE 5000

# 8. Define environment variable for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# 9. (Optional) Use Gunicorn for production instead of Flask's development server
# Install Gunicorn
RUN pip install gunicorn

# 10. Define the default command to run the app
# For Development:
# CMD ["flask", "run"]

# For Production (Recommended):
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]