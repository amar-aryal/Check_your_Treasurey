from django.db import models

from django.contrib.auth.models import User

class Budget(models.Model):
    plan = models.TextField()
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.plan


