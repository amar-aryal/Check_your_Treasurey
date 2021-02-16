from rest_framework import serializers
from .models import Income,Expense,Reminder

class IncomeSerializer(serializers.ModelSerializer):
    userID = serializers.ReadOnlyField(source='userID.id')

    class Meta:
        fields = [
            'id','incomename','category','amount','date','userID'
        ]

        model = Income

class ExpenseSerializer(serializers.ModelSerializer):
    userID = serializers.ReadOnlyField(source='userID.id')

    class Meta:
        fields = [
            'id','expensename','category','amount','date','userID'
        ]

        model = Expense

class ReminderSerializer(serializers.ModelSerializer):
    class Meta:
        fields = [
            'id','billName','billAmount','paymentDate','userID'
        ]

        model = Reminder