from django.contrib import admin
from .models import Income,Expense

class ExpenseAdmin(admin.ModelAdmin):
    list_display = ('id','expensename', 'category','amount','date','userID')
    list_display_links = ('date','id',)
    list_editable = ('expensename','amount')
    list_filter = ('category',)

class IncomeAdmin(admin.ModelAdmin):
    list_display = ('id','incomename','category','amount','date','userID')
    list_display_links = ('date','id',)
    list_editable = ('incomename','amount')
    list_filter = ('category',)

# Register your models here.
admin.site.register(Income,IncomeAdmin)
admin.site.register(Expense,ExpenseAdmin)

