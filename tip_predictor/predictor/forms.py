from django import forms
class TipForm(forms.Form):
    total_bill = forms.FloatField(label='Total Bill')
    size = forms.IntegerField(label='Size of Party')
    time = forms.ChoiceField(choices=[('Lunch', 'Lunch'), ('Dinner', 'Dinner')], label='Time of Day')
    day = forms.ChoiceField(choices=[('Thur', 'Thursday'), ('Fri', 'Friday'), ('Sat', 'Saturday'), ('Sun', 'Sunday')], label='Day of the Week')
    smoker = forms.ChoiceField(choices=[('Yes', 'Yes'), ('No', 'No')], label='Smoker')
    

