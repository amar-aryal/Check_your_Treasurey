from django.contrib import admin
from .models import Receipt

class ReceiptAdmin(admin.ModelAdmin):
    list_display = ('id','receiptImage', 'userID')
    list_display_links = ('id',)
    list_filter = ('userID',)
    
admin.site.register(Receipt, ReceiptAdmin)
