from rest_framework import serializers
from .models import Receipt

class ReceiptSerializer(serializers.ModelSerializer):
    receiptImage = serializers.ImageField(max_length=None, use_url=True)

    class Meta:
        model = Receipt
        fields = ('id','receiptImage','userID')