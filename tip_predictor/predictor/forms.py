from django import forms

class TipForm(forms.Form):
    total_bill = forms.FloatField(
        label='Total Bill ($)',
        widget=forms.NumberInput(attrs={
            'class': 'form-control',
            'placeholder': 'Enter total bill amount',
            'step': '0.01',
            'min': '0'
        })
    )
    
    sex = forms.ChoiceField(
        choices=[('Male', 'Male'), ('Female', 'Female')],
        label='Gender',
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    smoker = forms.ChoiceField(
        choices=[('Yes', 'Yes'), ('No', 'No')],
        label='Smoker',
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    day = forms.ChoiceField(
        choices=[('Thur', 'Thursday'), ('Fri', 'Friday'), ('Sat', 'Saturday'), ('Sun', 'Sunday')],
        label='Day of the Week',
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    time = forms.ChoiceField(
        choices=[('Lunch', 'Lunch'), ('Dinner', 'Dinner')],
        label='Time of Day',
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    
    size = forms.IntegerField(
        label='Party Size',
        widget=forms.NumberInput(attrs={
            'class': 'form-control',
            'placeholder': 'Number of people',
            'min': '1',
            'max': '10'
        })
    )
    

