from django.shortcuts import render
from rest_framework import generics
from .models import Receipt
from .serializers import ReceiptSerializer
from rest_framework.views import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .permissions import IsOwner

class ReceiptAPI(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,IsOwner)

    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only"""
        return self.queryset.filter(userID=self.request.user)

    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)

class ReceiptDetailsAPI(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = (IsAuthenticated,IsOwner)

    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer