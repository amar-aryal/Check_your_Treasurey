from django.shortcuts import render
from rest_framework import generics
from .models import Receipt
from .serializers import ReceiptSerializer
from rest_framework.views import Response
from rest_framework import status

class ReceiptAPI(generics.ListCreateAPIView):
    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer

    def post(self, request, format=None):
        serializer = ReceiptSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ReceiptDetailsAPI(generics.RetrieveUpdateDestroyAPIView):
    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer