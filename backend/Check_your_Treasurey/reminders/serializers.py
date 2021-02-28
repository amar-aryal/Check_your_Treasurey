from rest_framework import serializers
from .models import Reminder

class ReminderSerializer(serializers.ModelSerializer):
    class Meta:
        fields = [
            'id','billName','billAmount','paymentDate','userID'
        ]

        model = Reminder