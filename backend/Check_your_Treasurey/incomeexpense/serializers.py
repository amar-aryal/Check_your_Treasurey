from rest_framework import serializers
from .models import Income,Expense
from django.db.models.aggregates import Sum

class IncomeSerializer(serializers.ModelSerializer):
    userID = serializers.ReadOnlyField(source='userID.id')
    # total_income = serializers.SerializerMethodField()

    class Meta:
        fields = [
            'id','incomename','category','amount','date','userID',
        ]

        model = Income


class ExpenseSerializer(serializers.ModelSerializer):
    userID = serializers.ReadOnlyField(source='userID.id')

    class Meta:
        fields = [
            'id','expensename','category','amount','date','userID'
        ]

        model = Expense
