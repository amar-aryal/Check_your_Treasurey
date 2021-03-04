from django.db import models
from django.utils import timezone
from datetime import date
from django.contrib.auth.models import User
from django.db.models.aggregates import Sum

class Income(models.Model):
    incomename = models.CharField(max_length=100)
    category = models.CharField(max_length=50)
    amount = models.FloatField(null=False)
    date = models.DateField(default=date.today)
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    
    def __str__(self):
        return self.incomename
    
   
class Expense(models.Model):
    expensename = models.CharField(max_length=100)
    category = models.CharField(max_length=50)
    amount = models.FloatField(null=False)
    date = models.DateField(default=date.today)
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.expensename


    
