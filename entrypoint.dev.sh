#!/bin/sh

# Ensure the script exits if any command fails
set -e

echo "Applying database migrations for development..."
python manage.py migrate --noinput

echo "Starting Django development server..."
python manage.py runserver 0.0.0.0:8000