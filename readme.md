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
django-admin startproject tip_predictor .
```

## 5. create a django app

```bash
cd tip_predictor
python manage.py startapp predictor
```
