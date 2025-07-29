#!/bin/sh

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting Gunicorn server..."
exec gunicorn core.wsgi:application --bind 0.0.0.0:8000 --workers 4 --threads 2 --timeout 60