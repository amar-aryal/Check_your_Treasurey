from django.contrib import admin
from .models import Reminder


class ReminderAdmin(admin.ModelAdmin):
    list_display = ('id','billName', 'billAmount','paymentDate','userID')
    list_display_links = ('paymentDate','id',)
    list_editable = ('billName','billAmount')
    list_filter = ('userID',)
    

admin.site.register(Reminder, ReminderAdmin)
