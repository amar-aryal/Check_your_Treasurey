from django.urls import path
from .views import IncomeList, IncomeRUD, ExpenseList, ExpenseRUD

urlpatterns = [
    path('incomes/', IncomeList.as_view()),
    path('incomes/<int:pk>/', IncomeRUD.as_view()),
    path('expenses/', ExpenseList.as_view()),
    path('expenses/<int:pk>/', ExpenseRUD.as_view()),
    # path('total/', TotalValueAPI.as_view()),
]