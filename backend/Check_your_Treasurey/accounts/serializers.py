from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from incomeexpense.models import Expense

class UserSerializer(serializers.ModelSerializer):
    expense_set = serializers.PrimaryKeyRelatedField(many=True,read_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'expense_set')

class UserRegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email','password')
        extra_kwargs = {'password': {'write_only':True}}
    
    def create(self, validated_data):
        user = User.objects.create_user(validated_data['username'], validated_data['email'], validated_data['password'])

        return user

class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

    def validate(self, data):
        user = authenticate(**data)
        if user and user.is_active:
            return user
        raise serializers.ValidationError("Incorrect Credentials")