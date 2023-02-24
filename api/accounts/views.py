from django.shortcuts import render
from django.contrib.auth import get_user_model

from rest_framework import generics

from . serializers import UserSerializer

# Create your views here.
class UserList(generics.ListCreateAPIView):
    queryset = get_user_model().objects.all()
    serializer_class = UserSerializer

    