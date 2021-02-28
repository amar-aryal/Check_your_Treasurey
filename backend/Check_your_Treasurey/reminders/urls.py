from django.urls import path
from .views import ReminderListCreate,ReminderRUD

urlpatterns = [
    path('reminders/', ReminderListCreate.as_view()),
    path('reminders/<int:pk>/', ReminderRUD.as_view()),
]