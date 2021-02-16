from django.shortcuts import render

from .models import Income,Expense,Reminder
from .serializers import IncomeSerializer,ExpenseSerializer,ReminderSerializer
from rest_framework.views import APIView
from rest_framework.views import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from rest_framework import generics
from django.contrib.auth.models import User
from datetime import date

class IncomeList(generics.ListCreateAPIView): # for listing the incomes and creating incomes
    
    # def get(self,request,format=None):
    #     incomes = Income.objects.all()
    #     serializer = IncomeSerializer(incomes, many=True)
    #     return Response(serializer.data)

    # def get_queryset(self, pk):
    #     try:
    #         income = Income.objects.get(pk=pk)
    #     except Income.DoesNotExist:
    #         content = {
    #             'status': 'Not Found'
    #         }
    #         return Response(content, status=status.HTTP_404_NOT_FOUND)
    #     return income

    # def post(self,request,format=None):
    #     serializer = IncomeSerializer(data=request.data)
    #     if serializer.is_valid():
    #         serializer.save()
    #         return Response(serializer.data, status=status.HTTP_201_CREATED)
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    permission_classes = (IsAuthenticated,)
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only"""
        return self.queryset.filter(userID=self.request.user)
    
    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)

class IncomeRUD(generics.RetrieveUpdateDestroyAPIView): # for update and delete income
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer

class ExpenseList(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,)
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only"""
        return self.queryset.filter(userID=self.request.user)

    
    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)
    
class ExpenseRUD(generics.RetrieveUpdateDestroyAPIView):
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

class ReminderListCreate(generics.ListCreateAPIView):
    queryset = Reminder.objects.all()
    serializer_class = ReminderSerializer

class ReminderRUD(generics.RetrieveUpdateDestroyAPIView):
    queryset = Reminder.objects.all()
    serializer_class = ReminderSerializer