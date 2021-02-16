from django.db import models
from django.utils import timezone
from datetime import date
from django.contrib.auth.models import User

# class Category(models.Model):
#     categoryID = models.CharField(max_length=10)
#     categoryname = models.CharField(max_length=100)

#     def __str__(self):
#         return self.categoryname

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

class Reminder(models.Model):
    billName = models.CharField(max_length=100)
    billAmount = models.FloatField(null=False)
    paymentDate = models.DateField(default=date.today)
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.billName
