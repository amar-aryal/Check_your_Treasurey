from django.shortcuts import render
from .serializers import BudgetSerializer
from .models import Budget
from rest_framework.permissions import IsAuthenticated
from .permissions import IsOwner
from rest_framework import status
from rest_framework import generics

class BudgetListCreate(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Budget.objects.all()
    serializer_class = BudgetSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only"""
        return self.queryset.filter(userID=self.request.user)

    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)

class BudgetRUD(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Budget.objects.all()
    serializer_class = BudgetSerializer

