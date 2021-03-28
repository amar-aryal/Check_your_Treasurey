from django.urls import path,include
from .views import ReminderListCreate,ReminderRUD,Notify
from fcm_django.api.rest_framework import FCMDeviceViewSet

from rest_framework.routers import DefaultRouter

router = DefaultRouter()

router.register('devices',FCMDeviceViewSet)

urlpatterns = [
    path('reminders/', ReminderListCreate.as_view()),
    path('reminders/<int:pk>/', ReminderRUD.as_view()),
    path('',include(router.urls)),
    path('notify/', Notify.as_view()),
]
