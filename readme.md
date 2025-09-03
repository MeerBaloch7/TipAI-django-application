# Tip Predictor Django Application

A complete Django web application that uses machine learning to predict tip amounts based on various dining factors.

## Features

- **AI-Powered Predictions**: Uses XGBoost machine learning algorithm
- **Beautiful UI**: Modern Bootstrap-based responsive design with animations
- **Multiple Factors**: Considers 6 key features for accurate predictions:
  - Total bill amount
  - Party size
  - Gender
  - Smoking status
  - Day of the week
  - Time of day (lunch/dinner)

## Project Structure

```
ML_Django/
├── ml_project/              # Machine learning model development
│   ├── 01_ml.ipynb         # Jupyter notebook with model training
│   ├── data/
│   │   └── tips.csv        # Training dataset
│   └── model/
│       └── xgb_model.pkl   # Trained XGBoost model
└── tip_predictor/          # Django web application
    ├── manage.py
    ├── predictor/          # Main app
    │   ├── forms.py        # Django forms with Bootstrap styling
    │   ├── views.py        # Business logic and ML predictions
    │   ├── urls.py         # URL routing
    │   └── templates/      # HTML templates with modern design
    └── tip_predictor/      # Project settings
        ├── settings.py
        └── urls.py
```

## 1. Create a Virtual Environment

```bash
python -m venv .venv
.venv\Scripts\activate  # On Windows
# or
source .venv/bin/activate  # On Linux/Mac
```

## 2. Install Required Libraries

```bash
pip install django
pip install pandas numpy scikit-learn matplotlib seaborn
pip install joblib xgboost
pip install ipykernel  # for Jupyter notebook
```

## 3. Train the Machine Learning Model

The ML model has already been trained and saved. You can see the complete process in the [notebook](./ml_project/01_ml.ipynb) which includes:

1. Data loading from seaborn tips dataset
2. Feature encoding (categorical to numerical)
3. Model training with XGBoost
4. Model evaluation and comparison
5. Saving the model as `xgb_model.pkl`

## 4. Django Project Setup

The Django project has been created with the following structure:

```bash
# Project was created with:
django-admin startproject tip_predictor
cd tip_predictor
python manage.py startapp predictor
```

## 5. Key Components

### Forms (`predictor/forms.py`)
- Enhanced with Bootstrap styling and form validation
- Includes all 6 required features with proper field types
- User-friendly labels and placeholders

### Views (`predictor/views.py`)
- Handles form processing and ML predictions
- Implements proper feature encoding as per the ML model
- Error handling for model loading and predictions

### Templates
- **Base template**: Modern responsive design with Bootstrap 5
- **Home page**: Interactive prediction form with real-time validation
- **About page**: Information about the model and technology stack
- **Features**: Gradient backgrounds, animations, and modern UI components

### URLs
- Clean URL routing with app namespacing
- Integrated with main project URLs

## 6. Running the Application

1. **Navigate to the Django project:**
   ```bash
   cd tip_predictor
   ```

2. **Run migrations:**
   ```bash
   python manage.py migrate
   ```

3. **Start the development server:**
   ```bash
   python manage.py runserver
   ```

4. **Open your browser and visit:**
   ```
   http://127.0.0.1:8000/
   ```

## 7. Using the Application

1. Fill out the prediction form with dining details
2. Click "Predict Tip Amount"
3. View the AI-generated tip prediction
4. Explore the About page for more information

## Model Information

- **Algorithm**: XGBoost Regressor
- **Training Data**: Restaurant tips dataset from Seaborn
- **Accuracy**: High performance with low MAE and good R² score
- **Features**: 6 input features with categorical encoding:
  - Sex: Male=1, Female=0
  - Smoker: Yes=1, No=0
  - Day: Fri=0, Sat=1, Sun=2, Thur=3
  - Time: Dinner=0, Lunch=1

## Technology Stack

- **Backend**: Django 5.2.5
- **Frontend**: Bootstrap 5.1.3, Font Awesome 6.0
- **Machine Learning**: XGBoost, Scikit-learn
- **Database**: SQLite
- **Python**: 3.8+

## Screenshots

The application features:
- Modern gradient backgrounds
- Responsive card-based layout
- Interactive form elements
- Animated prediction results
- Professional navigation
- Information-rich about page

## Future Enhancements

- User authentication and prediction history
- Data visualization of predictions
- Model performance metrics dashboard
- Batch prediction capabilities
- API endpoints for external integration








