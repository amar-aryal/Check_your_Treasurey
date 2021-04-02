from django.shortcuts import render
from .serializers import ReminderSerializer
from .models import Reminder
from rest_framework.permissions import IsAuthenticated
from .permissions import IsOwner
from rest_framework import status
from rest_framework import generics
from rest_framework.views import APIView
from fcm_django.models import FCMDevice
from fcm_django.api.rest_framework import FCMDeviceSerializer

from rest_framework.views import Response


class ReminderListCreate(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Reminder.objects.all()
    serializer_class = ReminderSerializer

    def get_queryset(self):
        """Returns objects for current authenticated user only"""
        return self.queryset.filter(userID=self.request.user)

    def perform_create(self, serializer):
        """Assigns the logged in user's id to the object's userID foreign key"""
        serializer.save(userID=self.request.user)

class ReminderRUD(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = (IsAuthenticated,IsOwner)
    queryset = Reminder.objects.all()
    serializer_class = ReminderSerializer




