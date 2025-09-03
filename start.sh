#!/bin/bash

# Railway deployment script for TipAI
echo "🚂 Starting Railway deployment for TipAI..."

# Navigate to Django project
cd tip_predictor

# Run migrations
echo "📊 Running database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "📁 Collecting static files..."
python manage.py collectstatic --noinput

# Start the server
echo "🚀 Starting Django server..."
python manage.py runserver 0.0.0.0:$PORT
