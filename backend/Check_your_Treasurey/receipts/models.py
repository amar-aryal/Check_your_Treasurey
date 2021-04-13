from django.db import models
from django.contrib.auth.models import User

class Receipt(models.Model):
    receiptImage = models.ImageField(upload_to='Images/',default=None)
    userID = models.ForeignKey(User, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.receiptImage


