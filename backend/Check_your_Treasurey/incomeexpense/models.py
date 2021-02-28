from django.db import models
from django.utils import timezone
from datetime import date
from django.contrib.auth.models import User
from django.db.models.aggregates import Sum

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
    
    # def get_total_income(self):
    #     return Income.objects.filter(userID = self.request.user).aggregate(total=Sum('amount'))["total"]

class Expense(models.Model):
    expensename = models.CharField(max_length=100)
    category = models.CharField(max_length=50)
    amount = models.FloatField(null=False)
    date = models.DateField(default=date.today)
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.expensename

# class TotalValue(models.Model):
#     total_income = models.FloatField()
#     total_expense = models.FloatField()
#     userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

#     def __str__(self):
#         return self.userID

    # def save(self, *args, **kwargs):
    #     """calculates the total income and expenses"""
    #     user_total_income = Income.objects.filter(userID = self.request.user).aggregate(Sum('amount'))
    #     user_total_expense = Expense.objects.filter(userID = self.request.user).aggregate(Sum('amount'))
    #     self.income = user_total_income
    #     self.expense = user_total_expense
    #     super(TotalValue, self).save(*args, **kwargs)


    
