# Python ML model deployement through Django

this repository contains a simple Django application that demonstrates how to deploy a machine learning model using Django. The application allows users to input data and receive predictions from the model.

>create a readme.md file 

## 1. create a virtual environment

we will  use python env to create venv.

```bash
python -m venv venv
venv\Scripts\activate
```
## 2. install libraires

we will use pip to install the required libraries.

```bash
pip install  -r requirements.txt

# you can also install them manually
pip install django 
pip install pandas numpy scikit-learn matplotlib seaborn

# for saving model
pip install joblib

# jupyter notebook
pip install ipykernel
```

## 3. train the machine learning model

1. find the data
2. preprocess the data
3. train the model
4. evaluate the model
5. save the model using joblib


I have saved the model as `xgb_model.pkl` in the `model` directory.
> you can see the procedure of ml training and saving a model in this [notebook](./ml_project/01_ml.ipynb)


## 4. create a django project

```bash
# starting the project in the same main folder
django-admin startproject tip_predictor
cd tip_predictor
```

## 5. create a django app

```bash
cd tip_predictor
python manage.py startapp predictor
```


## 6. add the app to settings.py
add the app to the `INSTALLED_APPS` list in `settings.py`

```python
INSTALLED_APPS = [
    ...
    'predictor',
]
```

## 7. create a form for user input
create a file named `forms.py` in the `predictor` directory and add the following code:

```python
from django import forms
class TipForm(forms.Form):
    total_bill = forms.FloatField(label='Total Bill')
    size = forms.IntegerField(label='Size of Party')
    time = forms.ChoiceField(choices=[('Lunch', 'Lunch'), ('Dinner', 'Dinner')], label='Time of Day')
    day = forms.ChoiceField(choices=[('Thur', 'Thursday'), ('Fri', 'Friday'), ('Sat', 'Saturday'), ('Sun', 'Sunday')], label='Day of the Week )
    smoker = forms.ChoiceField(choices=[('Yes', 'Yes'), ('No', 'No')], label='Smoker')
    sex = forms.ChoiceField(choices=[('male'),('female')], label='Sex')
```








