from django.urls import path
from . import views

app_name = 'predictor'

urlpatterns = [
    path('', views.landing, name='landing'),
    path('predict/', views.predict, name='predict'),
    path('about/', views.about, name='about'),
    path('how-it-works/', views.how_it_works, name='how_it_works'),
    path('demo/', views.demo, name='demo'),
]
