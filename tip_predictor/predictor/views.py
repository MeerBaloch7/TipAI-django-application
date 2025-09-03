from django.shortcuts import render
from django.contrib import messages
from .forms import TipForm
import joblib
import os
import numpy as np
from pathlib import Path

# Load the ML model
BASE_DIR = Path(__file__).resolve().parent.parent.parent
MODEL_PATH = os.path.join(BASE_DIR, 'ml_project', 'model', 'xgb_model.pkl')

try:
    model = joblib.load(MODEL_PATH)
    print("Model loaded successfully!")
except Exception as e:
    print(f"Error loading model: {e}")
    model = None

def landing(request):
    """Landing page with hero section and features"""
    return render(request, 'predictor/landing.html')

def predict(request):
    """Prediction page with tip prediction form"""
    prediction = None
    
    if request.method == 'POST':
        form = TipForm(request.POST)
        if form.is_valid():
            # Get form data
            total_bill = form.cleaned_data['total_bill']
            sex = form.cleaned_data['sex']
            smoker = form.cleaned_data['smoker']
            day = form.cleaned_data['day']
            time = form.cleaned_data['time']
            size = form.cleaned_data['size']
            
            # Encode categorical variables according to the notebook
            # Sex encoding: Male=1, Female=0
            sex_encoded = 1 if sex == 'Male' else 0
            
            # Smoker encoding: Yes=1, No=0
            smoker_encoded = 1 if smoker == 'Yes' else 0
            
            # Day encoding: Fri=0, Sat=1, Sun=2, Thur=3
            day_mapping = {'Fri': 0, 'Sat': 1, 'Sun': 2, 'Thur': 3}
            day_encoded = day_mapping[day]
            
            # Time encoding: Dinner=0, Lunch=1
            time_encoded = 1 if time == 'Lunch' else 0
            
            # Prepare features for prediction
            # Order: [total_bill, sex, smoker, day, time, size]
            features = np.array([[total_bill, sex_encoded, smoker_encoded, day_encoded, time_encoded, size]])
            
            # Make prediction
            if model is not None:
                try:
                    prediction = model.predict(features)[0]
                    prediction = round(prediction, 2)
                    
                    # Calculate tip percentage
                    tip_percentage = round((prediction / total_bill) * 100, 1)
                    
                    messages.success(request, f'Prediction successful! Estimated tip: ${prediction} ({tip_percentage}%)')
                except Exception as e:
                    messages.error(request, f'Error making prediction: {e}')
            else:
                messages.error(request, 'Model not loaded. Please check the model file.')
    else:
        form = TipForm()
    
    context = {
        'form': form,
        'prediction': prediction,
    }
    
    return render(request, 'predictor/predict.html', context)

def about(request):
    """About page with information about the tip predictor"""
    return render(request, 'predictor/about.html')

def how_it_works(request):
    """How it works page explaining the ML process"""
    return render(request, 'predictor/how_it_works.html')

def demo(request):
    """Demo page with sample predictions"""
    # Sample data for demonstration
    sample_predictions = [
        {
            'scenario': 'Weekend Dinner for 4',
            'details': {
                'total_bill': 85.50,
                'sex': 'Male',
                'smoker': 'No',
                'day': 'Sat',
                'time': 'Dinner',
                'size': 4
            },
            'predicted_tip': 12.75,
            'tip_percentage': 14.9
        },
        {
            'scenario': 'Weekday Lunch for 2',
            'details': {
                'total_bill': 32.40,
                'sex': 'Female',
                'smoker': 'No',
                'day': 'Thur',
                'time': 'Lunch',
                'size': 2
            },
            'predicted_tip': 4.85,
            'tip_percentage': 15.0
        },
        {
            'scenario': 'Friday Night Out',
            'details': {
                'total_bill': 125.00,
                'sex': 'Male',
                'smoker': 'Yes',
                'day': 'Fri',
                'time': 'Dinner',
                'size': 6
            },
            'predicted_tip': 18.20,
            'tip_percentage': 14.6
        }
    ]
    
    context = {
        'sample_predictions': sample_predictions,
    }
    
    return render(request, 'predictor/demo.html', context)
