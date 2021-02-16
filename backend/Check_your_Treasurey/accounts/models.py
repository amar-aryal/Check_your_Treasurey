from django.db import models

# class Receipt(models.Model):
#     receiptID = models.CharField(max_length=10)
#     receiptimage = models.ImageField()
#     userID = models.ForeignKey(User, on_delete=models.CASCADE)

#     def __init__(self):
#         return self.receiptID

# class Budget_Plan(models.Model):
#     budgetID = models.CharField(max_length=10)
#     description = models.CharField(max_length=100)
#     userID = models.ForeignKey(User, on_delete=models.CASCADE)

#     def __init__(self):
#         return self.description

# class Reminder(models.Model):
#     reminderID = models.CharField(max_length=10)
#     remindername = models.CharField(max_length=100)
#     date = models.DateTimeField(default=timezone.now)
#     userID = models.ForeignKey(User, on_delete=models.CASCADE)

#     def __init__(self):
#         return self.remindername

# class Report(models.Model):
#     reportID = models.CharField(max_length=10)
#     monthandyear = models.DateTimeField(default=timezone.now)
#     incometotal = models.FloatField()
#     expensetotal = models.FloatField() 
#     savings = models.FloatField() 
#     userID = models.ForeignKey(User, on_delete=models.CASCADE)

#     def __init__(self):
#         return self.reportID

