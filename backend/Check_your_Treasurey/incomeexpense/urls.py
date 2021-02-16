from django.urls import path
from .views import IncomeList, IncomeRUD, ExpenseList, ExpenseRUD, ReminderListCreate,ReminderRUD

urlpatterns = [
    path('incomes/', IncomeList.as_view()),
    path('incomes/<int:pk>/', IncomeRUD.as_view()),
    path('expenses/', ExpenseList.as_view()),
    path('expenses/<int:pk>/', ExpenseRUD.as_view()),
    path('reminders/', ReminderListCreate.as_view()),
    path('reminders/<int:pk>/', ReminderRUD.as_view()),
]