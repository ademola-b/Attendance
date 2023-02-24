from django.contrib.auth import get_user_model

from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        # fields = ['id', 'first_name', 'last_name', 'user_type', 'username']
        fields = '__all__'
        display_field = ['username', 'user_type']