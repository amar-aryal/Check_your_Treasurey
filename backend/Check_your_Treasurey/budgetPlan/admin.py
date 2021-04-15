from django.contrib import admin
from .models import Budget


class BudgetAdmin(admin.ModelAdmin):
    list_display = ('id','plan', 'userID')
    list_display_links = ('id',)
    list_editable = ('plan',)
    list_filter = ('userID',)

admin.site.register(Budget, BudgetAdmin)