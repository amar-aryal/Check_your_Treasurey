from django.db import models
from django.contrib.auth.models import User
from datetime import date

class Reminder(models.Model):
    billName = models.CharField(max_length=100)
    billAmount = models.FloatField(null=False)
    paymentDate = models.DateField(default=date.today)
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.billName

