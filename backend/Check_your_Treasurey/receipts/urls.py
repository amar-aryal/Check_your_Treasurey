from django.urls import path
from . import views
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('receipts/', views.ReceiptAPI.as_view()),
    path('receipts/<int:pk>', views.ReceiptDetailsAPI.as_view()),

]+static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)