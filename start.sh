#!/bin/bash

# Railway deployment script for Django tip predictor

set -e  # Exit on any error

echo "Starting Railway deployment..."

# Change to the Django project directory
cd /app/tip_predictor

# Create staticfiles directory if it doesn't exist
mkdir -p /app/staticfiles
mkdir -p /app/media

# Run database migrations
echo "Running database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start the Django application with Gunicorn
echo "Starting Django application..."
exec gunicorn --bind 0.0.0.0:$PORT --workers 3 tip_predictor.wsgi:application
