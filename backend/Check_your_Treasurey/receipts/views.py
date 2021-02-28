from django.shortcuts import render
from rest_framework import generics
from .models import Receipt
from .serializers import ReceiptSerializer

class ReceiptAPI(generics.ListCreateAPIView):
    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer

class ReceiptDetailsAPI(generics.RetrieveUpdateDestroyAPIView):
    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer