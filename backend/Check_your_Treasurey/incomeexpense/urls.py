from django.urls import path
from . import views
from .views import IncomeList, IncomeRUD, ExpenseList, ExpenseRUD, IncomeExpenseDailyStats, MonthlyStats, ReportPdfView, ExportToExcel,RecentExpenses,RecentIncomes

urlpatterns = [
    path('incomes/', IncomeList.as_view()),
    path('incomes/<int:pk>/', IncomeRUD.as_view()),
    path('expenses/', ExpenseList.as_view()),
    path('expenses/<int:pk>/', ExpenseRUD.as_view()),
    path('today_total/', IncomeExpenseDailyStats.as_view()),
    path('monthly_total/', MonthlyStats.as_view()),
    path('report/',ReportPdfView.as_view()),
    path('export/',ExportToExcel.as_view()),
    path('recentExpenses/',RecentExpenses.as_view()),
    path('recentIncomes/',RecentIncomes.as_view()),
]