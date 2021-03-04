from django.urls import path
from . import views
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('budget/', views.BudgetListCreate.as_view()),
    path('budget/<int:pk>', views.BudgetRUD.as_view()),
]