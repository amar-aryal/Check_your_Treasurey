from django.shortcuts import render

from .models import Income,Expense
from .serializers import IncomeSerializer,ExpenseSerializer
from rest_framework.views import APIView
from rest_framework.views import Response
from rest_framework.permissions import IsAuthenticated
from .permissions import IsOwner
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

    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only and the date passed as url parameter"""
        return self.queryset.filter(userID=self.request.user, date=self.request.query_params.get('date', None))
    
    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)

class IncomeRUD(generics.RetrieveUpdateDestroyAPIView): # for update and delete income
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer


class ExpenseList(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only and the date passed as url parameter"""
        return self.queryset.filter(userID=self.request.user, date=self.request.query_params.get('date', None))

    
    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)
    
class ExpenseRUD(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

# class TotalValueAPI(generics.ListAPIView):
#     queryset = TotalValue.objects.all()
#     serializer_class = TotalSerializer