#!/bin/bash

# Heroku release script
cd tip_predictor
python manage.py migrate --noinput
